Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730068.outbound.protection.outlook.com ([40.107.73.68]:2176
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729099AbeK1CjN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:39:13 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 02/14] tools/lib/traceevent: Added support for pkg-config
Date: Tue, 27 Nov 2018 15:40:53 +0000
Message-ID: <20181127154038.11175-3-tstoyanov@vmware.com>
References: <20181127154038.11175-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154038.11175-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch implements integration with pkg-config framework.
pkg-config can be used by the library users to determine
required CFLAGS and LDFLAGS in order to use the library

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Makefile                 | 26 ++++++++++++++++---
 .../lib/traceevent/libtraceevent.pc.template  | 10 +++++++
 2 files changed, 33 insertions(+), 3 deletions(-)
 create mode 100644 tools/lib/traceevent/libtraceevent.pc.template

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 0b4e833088a4..05ac0ec9bcd1 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -25,6 +25,7 @@ endef
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
 $(call allow-override,NM,$(CROSS_COMPILE)nm)
+$(call allow-override,PKG_CONFIG,pkg-config)
=20
 EXT =3D -std=3Dgnu99
 INSTALL =3D install
@@ -47,6 +48,8 @@ prefix ?=3D /usr/local
 libdir =3D $(prefix)/$(libdir_relative)
 man_dir =3D $(prefix)/share/man
 man_dir_SQ =3D '$(subst ','\'',$(man_dir))'
+pkgconfig_dir ?=3D $(word 1,$(shell $(PKG_CONFIG) 		\
+			--variable pc_path pkg-config | tr ":" " "))
=20
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
@@ -270,7 +273,19 @@ define do_generate_dynamic_list_file
 	fi
 endef
=20
-install_lib: all_cmd install_plugins
+PKG_CONFIG_FILE =3D libtraceevent.pc
+define do_install_pkgconfig_file
+	if [ -n "${pkgconfig_dir}" ]; then 					\
+		cp -f ${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
+		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
+		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
+		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
+	else 									\
+		(echo Failed to locate pkg-config directory) 1>&2;		\
+	fi=09
+endef
+
+install_lib: all_cmd install_plugins install_pkgconfig
 	$(call QUIET_INSTALL, $(LIB_TARGET)) \
 		$(call do_install_mkdir,$(libdir_SQ)); \
 		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
@@ -279,6 +294,10 @@ install_plugins: $(PLUGINS)
 	$(call QUIET_INSTALL, trace_plugins) \
 		$(call do_install_plugins, $(PLUGINS))
=20
+install_pkgconfig:
+	$(call QUIET_INSTALL, $(PKG_CONFIG_FILE)) \
+		$(call do_install_pkgconfig_file,$(prefix))
+
 install_headers:
 	$(call QUIET_INSTALL, headers) \
 		$(call do_install,event-parse.h,$(prefix)/include/traceevent,644); \
@@ -289,8 +308,9 @@ install: install_lib
=20
 clean:
 	$(call QUIET_CLEAN, libtraceevent) \
-		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d .*.cmd \
-		$(RM) TRACEEVENT-CFLAGS tags TAGS
+		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d .*.cmd; \
+		$(RM) TRACEEVENT-CFLAGS tags TAGS; \
+		$(RM) $(PKG_CONFIG_FILE)
=20
 PHONY +=3D force plugins
 force:
diff --git a/tools/lib/traceevent/libtraceevent.pc.template b/tools/lib/tra=
ceevent/libtraceevent.pc.template
new file mode 100644
index 000000000000..42e4d6cb6b9e
--- /dev/null
+++ b/tools/lib/traceevent/libtraceevent.pc.template
@@ -0,0 +1,10 @@
+prefix=3DINSTALL_PREFIX
+libdir=3D${prefix}/lib64
+includedir=3D${prefix}/include/traceevent
+
+Name: libtraceevent
+URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+Description: Linux kernel trace event library
+Version: LIB_VERSION
+Cflags: -I${includedir}
+Libs: -L${libdir} -ltraceevent
--=20
2.19.1
