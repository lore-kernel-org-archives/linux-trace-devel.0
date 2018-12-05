Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710054.outbound.protection.outlook.com ([40.107.71.54]:10064
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726918AbeLEJV4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:21:56 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 5/6] tools lib traceevent: Added support for pkg-config
Date: Wed, 5 Dec 2018 09:21:52 +0000
Message-ID: <20181205092134.2214-6-tstoyanov@vmware.com>
References: <20181205092134.2214-1-tstoyanov@vmware.com>
In-Reply-To: <20181205092134.2214-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch implements integration with pkg-config framework.  pkg-config
can be used by the library users to determine required CFLAGS and
LDFLAGS in order to use the library

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181130154647.022471992@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile                                 | 44 ++++++++++++++++++++----
 lib/traceevent/libtraceevent.pc.template | 10 ++++++
 2 files changed, 48 insertions(+), 6 deletions(-)
 create mode 100644 lib/traceevent/libtraceevent.pc.template

diff --git a/Makefile b/Makefile
index 7ee9e0d..8dbba58 100644
--- a/Makefile
+++ b/Makefile
@@ -29,6 +29,7 @@ endef
 # Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
+$(call allow-override,PKG_CONFIG,pkg-config)
=20
 EXT =3D -std=3Dgnu99
 INSTALL =3D install
@@ -40,6 +41,13 @@ INSTALL =3D install
 DESTDIR ?=3D
 DESTDIR_SQ =3D '$(subst ','\'',$(DESTDIR))'
=20
+LP64 :=3D $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+ifeq ($(LP64), 1)
+  libdir_relative =3D lib64
+else
+  libdir_relative =3D lib
+endif
+
 prefix ?=3D /usr/local
 bindir_relative =3D bin
 bindir =3D $(prefix)/$(bindir_relative)
@@ -49,10 +57,16 @@ html_install =3D $(prefix)/share/kernelshark/html
 html_install_SQ =3D '$(subst ','\'',$(html_install))'
 img_install =3D $(prefix)/share/kernelshark/html/images
 img_install_SQ =3D '$(subst ','\'',$(img_install))'
-libdir ?=3D $(prefix)/lib
+libdir ?=3D $(prefix)/$(libdir_relative)
 libdir_SQ =3D '$(subst ','\'',$(libdir))'
-includedir =3D $(prefix)/include/trace-cmd
-includedir_SQ =3D '$(subst ','\'',$(includedir))'
+includedir_libtrace_relative =3D traceevent
+includedir_tc_relative =3D trace-cmd
+includedir_tc =3D $(prefix)/include/$(includedir_tc_relative)
+includedir_libtrace =3D $(prefix)/include/$(includedir_libtrace_relative)
+includedir_tc_SQ =3D '$(subst ','\'',$(includedir_tc))'
+includedir_libtrace_SQ =3D '$(subst ','\'',$(includedir_libtrace))'
+pkgconfig_dir ?=3D $(word 1,$(shell $(PKG_CONFIG) 		\
+			--variable pc_path pkg-config | tr ":" " "))
=20
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
@@ -305,6 +319,20 @@ show_gui_make:
=20
 PHONY +=3D show_gui_make
=20
+PKG_CONFIG_FILE =3D libtraceevent.pc
+define do_install_pkgconfig_file
+	if [ -n "${pkgconfig_dir}" ]; then 					\
+		cp -f lib/traceevent/${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
+		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
+		sed -i "s|LIB_VERSION|${TRACECMD_VERSION}|g" ${PKG_CONFIG_FILE}; \
+		sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
+		sed -i "s|HEADER_DIR|$(includedir_libtrace)|g" ${PKG_CONFIG_FILE}; \
+		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
+	else 									\
+		(echo Failed to locate pkg-config directory) 1>&2;		\
+	fi
+endef
+
 define find_tag_files
 	find . -name '\.pc' -prune -o -name '*\.[ch]' -print -o -name '*\.[ch]pp'=
 \
 		! -name '\.#' -print
@@ -322,6 +350,9 @@ cscope: force
 	$(RM) cscope*
 	$(call find_tag_files) | cscope -b -q
=20
+install_pkgconfig:
+	$(Q)$(call do_install_pkgconfig_file,$(prefix))
+
 install_plugins: force
 	$(Q)$(MAKE) -C $(src)/plugins $@
=20
@@ -341,11 +372,11 @@ install: install_cmd
 install_gui: install_cmd gui
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
=20
-install_libs: libs
+install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
 	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
-	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedi=
r_SQ))
-	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_S=
Q))
+	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedi=
r_libtrace_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_t=
c_SQ))
=20
 doc:
 	$(MAKE) -C $(src)/Documentation all
@@ -359,6 +390,7 @@ install_doc:
 clean:
 	$(RM) *.o *~ *.a *.so .*.d
 	$(RM) tags TAGS cscope*
+	$(RM) -f $(PKG_CONFIG_FILE)
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
 	$(MAKE) -C $(src)/kernel-shark clean
diff --git a/lib/traceevent/libtraceevent.pc.template b/lib/traceevent/libt=
raceevent.pc.template
new file mode 100644
index 0000000..86384fc
--- /dev/null
+++ b/lib/traceevent/libtraceevent.pc.template
@@ -0,0 +1,10 @@
+prefix=3DINSTALL_PREFIX
+libdir=3DLIB_DIR
+includedir=3DHEADER_DIR
+
+Name: libtraceevent
+URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+Description: Linux kernel trace event library
+Version: LIB_VERSION
+Cflags: -I${includedir}
+Libs: -L${libdir} -ltraceevent
--=20
2.19.2
