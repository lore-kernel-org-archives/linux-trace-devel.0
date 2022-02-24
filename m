Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B3DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 08:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiBXIxR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 03:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiBXIxQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 03:53:16 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB289162025
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 00:52:45 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id d10so2777018eje.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 00:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qxADE7W8Bvd+VlGLgA/i+sLqCEURQa+Foncw8JcGNzw=;
        b=FlQ6teRgVK30vLZSUyOubH+hMLevvob2Km1uNg8A8Fkakol7Vr5UbcucTQ+L/hBcMm
         EkgfldaOMJhWA5E70BO5S7KDA19l7+AROJ2YR7+i78U7m8vIy/5vI1KfbD0Y6qnPwR/R
         6rKfncyIRK7hFi8M2eMNaJtRcQmKSNhsKNf5nvRB4dwclN7QllNDD1kEe496j9I274Hl
         6xg0MQKmXe3GhWGpUCsXeGHmmJCClYxCom5uTXDBOUdpuDkgs18wx8Ba+WBaZerGUMF7
         Ifw6okKAw5wX+LvshcoC5GVW/UmM3SJhHDFuJFA76af589bSFB4ySYQ5Nu5ojMLooE60
         oaQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qxADE7W8Bvd+VlGLgA/i+sLqCEURQa+Foncw8JcGNzw=;
        b=BGSGZ+J78+M1rvhy8M3yG0eqyVds1kzIm6EfUpkHOGIsqG4o0T6G/IIjKB0VLunz0l
         lU55gSvgziO/9lyfwEm5RhJ3POJZ3+Mxu/K50kH8WaZph8q3Y+Y/vdtKNGpuXW4ZW7SJ
         QrdVVOQGy9WbqliMR9e2QVOAXLbq+Kr+Szr4AnTfeJ3fHQY0i0AzzcLTEnrsqh9VUzJp
         ss17IruTlxfhVFCadGEPAI3uJwYMMdmG8oUjuzrIX2aV+C7Te55j9AJ9lZ47oVG5gRsa
         49KclPYawBcTGuT3tyYaKJPOvB1MYCIhiRtVJz++NRiuFvkvp4I3cDVCcJ+e1qHzZ8MH
         HQ7w==
X-Gm-Message-State: AOAM530mwxb6nSVS2syKoL5KimzMv1M+IWsbTUBo+h3SDwYFQ5QG8PGl
        hOcunAVO6stDGLyT1Z+1UrY8cSECd5E=
X-Google-Smtp-Source: ABdhPJzh+QoySG79Zu0Z6J+IIoMSgfCK0QO5WKTVPocYISihaL/DkRhU3qLFIbmvkl6pZ46voQiWbg==
X-Received: by 2002:a17:906:2ec6:b0:69f:286a:66ab with SMTP id s6-20020a1709062ec600b0069f286a66abmr1464543eji.684.1645692764119;
        Thu, 24 Feb 2022 00:52:44 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id el5sm947254edb.71.2022.02.24.00.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 00:52:43 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Check required library versions before building
Date:   Thu, 24 Feb 2022 10:52:33 +0200
Message-Id: <20220224085233.112129-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not build trace-cruncher if the minimum version required for some
of the third party libraries is not found.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 setup.py | 52 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/setup.py b/setup.py
index 4d7e727..c9c0142 100644
--- a/setup.py
+++ b/setup.py
@@ -5,6 +5,7 @@ SPDX-License-Identifier: LGPL-2.1
 
 Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
 """
+import sys
 
 from setuptools import setup, find_packages
 from distutils.core import Extension
@@ -13,24 +14,45 @@ from Cython.Build import cythonize
 import pkgconfig as pkg
 import numpy as np
 
+def version_check(lib, lib_version, min_version):
+    min_v = min_version.split('.')
+    lib_v = pkg.modversion(lib).split('.')
+    if lib_v[2] == 'dev':
+        lib_v[2] = '0'
+
+    if tuple(map(int, lib_v)) < tuple(map(int, min_v)):
+        print('{0} v{1} is required'.format(lib, min_version))
+        return False
+    return True
+
+def add_library(lib, min_version,
+                libs_found,
+                library_dirs,
+                include_dirs):
+    pkg_info = pkg.parse(lib)
+    lib_version = pkg.modversion(lib)
+    if version_check(lib, lib_version, min_version):
+        include_dirs.extend(pkg_info['include_dirs'])
+        library_dirs.extend(pkg_info['library_dirs'])
+        libs_found.extend([(lib, lib_version)])
 
 def third_party_paths():
-    pkg_traceevent = pkg.parse('libtraceevent')
-    pkg_ftracepy = pkg.parse('libtracefs')
-    pkg_tracecmd = pkg.parse('libtracecmd')
-    pkg_kshark = pkg.parse('libkshark')
-
+    library_dirs = []
     include_dirs = [np.get_include()]
-    include_dirs.extend(pkg_traceevent['include_dirs'])
-    include_dirs.extend(pkg_ftracepy['include_dirs'])
-    include_dirs.extend(pkg_tracecmd['include_dirs'])
-    include_dirs.extend(pkg_kshark['include_dirs'])
+    libs_required = [('libtraceevent', '1.5.0'),
+                     ('libtracefs',    '1.3.0'),
+                     ('libkshark',     '2.0.1')]
+    libs_found = []
+
+    for lib in libs_required:
+        add_library(lib[0], lib[1],
+                    libs_found,
+                    library_dirs,
+                    include_dirs)
+
+    if len(libs_found) < len(libs_required):
+        sys.exit(1)
 
-    library_dirs = []
-    library_dirs.extend(pkg_traceevent['library_dirs'])
-    library_dirs.extend(pkg_ftracepy['library_dirs'])
-    library_dirs.extend(pkg_tracecmd['library_dirs'])
-    library_dirs.extend(pkg_kshark['library_dirs'])
     library_dirs = list(set(library_dirs))
 
     return include_dirs, library_dirs
@@ -52,7 +74,7 @@ def main():
                           sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
                           libraries=['traceevent', 'tracefs'])
 
-    cythonize('src/npdatawrapper.pyx', language_level = "3")
+    cythonize('src/npdatawrapper.pyx', language_level = '3')
     module_data = extension(name='tracecruncher.npdatawrapper',
                             sources=['src/npdatawrapper.c'],
                             libraries=['kshark'])
-- 
2.32.0

