PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
GIT="${GIT_DIR}/bin/git"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
SICKCHILL="${SYNOPKG_PKGDEST}/var/SickChill/SickBeard.py"
LOG_FILE="${SYNOPKG_PKGDEST}/var/Logs/sickchill.log"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="${PYTHON} ${SICKCHILL} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGDEST}/var/"

service_preinst ()
{
    SSL_CRT="/etc/ssl/certs/ca-certificates.crt"
    if [ -f ${SSL_CRT} ]; then
        ${GIT} config --system http.sslCAInfo ${SSL_CRT} > /dev/null 2>&1
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    # ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone --depth 10 --recursive -q git://github.com/SickChill/SickChill.git} ${SYNOPKG_PKGDEST}/var/SickChill > /dev/null 2>&1
    fi

    # Install the wheels
    # ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl > /dev/null 2>&1
    # ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/var/SickChill/requirements.txt

    # Set username and password
    sed -i "s/\(web_username *= *\).*/\1${wizard_web_username}/" ${SYNOPKG_PKGDEST}/var/config.ini
    sed -i "s/\(web_password *= *\).*/\1${wizard_web_password}/" ${SYNOPKG_PKGDEST}/var/config.ini
    sed -i "s/\(web_port *= *\).*/\18081/" ${SYNOPKG_PKGDEST}/var/config.ini

    # Create logs directory, otherwise it might not start
    mkdir "$(dirname ${LOG_FILE})" >> ${INST_LOG} 2>&1

    # If necessary, add user also to the old group before removing it
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users" >> ${INST_LOG}
    deluser "${USER}" >> ${INST_LOG}
}
