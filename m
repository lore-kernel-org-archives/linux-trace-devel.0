Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7297AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 30 Apr 2022 10:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382554AbiD3Kcg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 30 Apr 2022 06:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241493AbiD3Kcg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 30 Apr 2022 06:32:36 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3522D1DC
        for <linux-trace-devel@vger.kernel.org>; Sat, 30 Apr 2022 03:29:14 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i27so19643953ejd.9
        for <linux-trace-devel@vger.kernel.org>; Sat, 30 Apr 2022 03:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=omTRKCRvsxRgs0JeBBMOS3y9AIqig0qv75n3AENhnwo=;
        b=mgpHluRi3lGSdYG/jEHYxUUpMRLkQ4h7YYsM3tcK9h9LWSUf/AdsIoo6snI6rX/VGW
         G2jZ94BnHgypLB4egsV6tlkl1B99n7EwtlIlAhHLaTwWkveVS2pqmvtFhvw6DYo6Y0nE
         TF5/+iMWOaNrUGHpSnMFGwHJcbn19bAomNBuTpYB5NvIWKfyeEuzzuNmudH7JIxaTvuD
         xH1YoBJtBwI99mxC4F3VvYR+AHTTa2uHI6tiYmOzB9mImn1oGqsEmsnbUDYXbKVnEttl
         JmsIZDr9YaOK9eC4A20j+pmqig8NZgCmZOCCoj26WPK1NG7Rlwzh40sCF5DjJDUhpifD
         DDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=omTRKCRvsxRgs0JeBBMOS3y9AIqig0qv75n3AENhnwo=;
        b=Wj5WchC2/vyf4IckhVxOwMdO2PYhoE5RFseRb0TltuSWtFSqIwE4Qh5btLfZNVtkg0
         HfUkcE13fKyITE51vW+urAVV7JHUIN5xRCP+C722++frRdrCQYpTkEphbkD3mCGSUhI0
         erL9UPDkGd1lmfNf8s/cbrXPu9qmKeudYAaDc5GoXwGyVePv6OgIgXtJDsaer1xwi2Bn
         pcvKBdDWl+MzwM6hlwLht4t7e5pk/VVwJuhnFRoovkWK6eJT9+W7m0jgaXCJgKPWnBzF
         zVCtMJpkqIvWSfazgq/wtE9pQfpBWY52pEnCT6SeEgMpelTqkoIau9RHEtBcw8S1neLZ
         4p9A==
X-Gm-Message-State: AOAM532XiK9+JSAXeHRk73wSSqFH77sdPhB2e2+o2SSshWBPxT+Ue4yu
        wwlQ3MLbcClYyRsXMdzQh4l1H+pgYsY=
X-Google-Smtp-Source: ABdhPJwYELojMFHGNtVEbvgKprxRZhG2R0OCYBMVq/gt+MLzzx2B2J9IL7NJXNu8fN0HRO57+lqJ4w==
X-Received: by 2002:a17:907:6e07:b0:6f3:c01b:4890 with SMTP id sd7-20020a1709076e0700b006f3c01b4890mr3188645ejc.678.1651314552721;
        Sat, 30 Apr 2022 03:29:12 -0700 (PDT)
Received: from crow.. (78-154-13-120.ip.btc-net.bg. [78.154.13.120])
        by smtp.gmail.com with ESMTPSA id jl25-20020a17090775d900b006f3ef214dc5sm1489603ejc.43.2022.04.30.03.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 03:29:11 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] trace-cruncher: Build trace-obj-debug.c as library
Date:   Sat, 30 Apr 2022 13:28:59 +0300
Message-Id: <20220430102859.1769397-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The code for resolving virtual address to function name gets build
as shared library. The library is installed as package data. Later
this library can be used by the different sub-modules of tracecruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---

This patch applies on top of the patch:
https://lore.kernel.org/all/20220420080206.252356-2-tz.stoyanov@gmail.com/

Changes in v2:
 - Fixing the problem of '$ORIGIN' not being properly added to
   the 'RUNPATH' of the shared libraries, built by the sub-modules. 

 Makefile | 24 +++++++++++++++++++++---
 setup.py |  4 ++--
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 52428c0..9b62c4a 100644
--- a/Makefile
+++ b/Makefile
@@ -13,13 +13,31 @@ NC	:= '\e[0m'
 
 DOCDIR = ./docs
 
-all:
+CC = gcc
+CFLAGS = -fPIC -Wall -Wextra -O2 -g
+LDFLAGS = -shared
+RM = rm -rf
+
+DBG_LIB = tracecruncher/libobjdebug.so
+PY_SETUP = setup
+
+DBG_SRCS = src/trace-obj-debug.c
+DBG_OBJS = src/trace-obj-debug.o
+
+all: $(DBG_LIB) $(PY_SETUP)
 	@ echo ${CYAN}Buildinging trace-cruncher:${NC};
+
+$(PY_SETUP):
 	python3 setup.py build
 
+$(DBG_LIB): $(DBG_OBJS)
+	$(CC) ${LDFLAGS} -o $@ $^ -L./tracecruncher -lbfd
+
 clean:
-	rm -f src/npdatawrapper.c
-	rm -rf build
+	${RM} src/npdatawrapper.c
+	${RM} $(DBG_LIB)
+	${RM} src/*.o
+	${RM} build
 
 install:
 	@ echo ${CYAN}Installing trace-cruncher:${NC};
diff --git a/setup.py b/setup.py
index 58561cf..d9e296b 100644
--- a/setup.py
+++ b/setup.py
@@ -37,7 +37,7 @@ def add_library(lib, min_version,
         libs_found.extend([(lib, lib_version)])
 
 def third_party_paths():
-    library_dirs = []
+    library_dirs = ['$ORIGIN', 'tracecruncher']
     include_dirs = [np.get_include()]
     libs_required = [('libtraceevent', '1.5.0'),
                      ('libtracefs',    '1.3.0'),
@@ -61,7 +61,6 @@ include_dirs, library_dirs = third_party_paths()
 
 def extension(name, sources, libraries):
     runtime_library_dirs = library_dirs
-    runtime_library_dirs.extend('$ORIGIN')
     return Extension(name, sources=sources,
                            include_dirs=include_dirs,
                            library_dirs=library_dirs,
@@ -91,6 +90,7 @@ def main():
           url='https://github.com/vmware/trace-cruncher',
           license='LGPL-2.1',
           packages=find_packages(),
+          package_data={'tracecruncher': ['libobjdebug.so']},
           ext_modules=[module_ft, module_data, module_ks],
           classifiers=[
               'Development Status :: 4 - Beta',
-- 
2.32.0

