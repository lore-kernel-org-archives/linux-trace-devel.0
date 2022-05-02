Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC0AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 May 2022 10:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiEBKKb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 May 2022 06:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384400AbiEBKK1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 May 2022 06:10:27 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A3D165A4
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 May 2022 03:06:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l7so26879878ejn.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 May 2022 03:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ob9ux/zbTVXLZlgvICfRbEV/PoUIbSKC+kwYN1JUNiA=;
        b=iOQxKhjFQkAU75HqCDtspJXKmcmzkmxDqfXnlcqXolYMWb3LA7ZVx3Cdt9FdIX2xVe
         b/r3yyH1SFANKB5VLh+YO4b10pQ1MVUZupRULjbEnTs9VWiCKmspN3unI24IUK15FIYt
         aStp8ChZSeqQp3E0fZQhPEjUTh/5k7CKyA99GduLCssE5YC6DafBC8Yo9us38yv1/RTV
         QvaHznuf29tVFt3YgGnbKGp+7snGDeHcDZbg0Nm4W5zEcc2vy2bg6F++2gdGno6lTs5U
         DYDbja+GEVNi7pwH6081YxhqSpqW/FMN6YBiQPV6C2/QTnfYZiTTZUL3oLU4D4G66/gZ
         n2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ob9ux/zbTVXLZlgvICfRbEV/PoUIbSKC+kwYN1JUNiA=;
        b=k4NU3o4N88qlI4rgU222Pxn8oPGinW43t7t3aCfrdrSzo1TJfHsvFNWOFr53de5pfH
         ow9XCXnhrx5N48L/DrtP54Er8kkI1PzZBe48KbqVwA7s2oO203ZL/eFndMSQBeyvZAJH
         A8103VEwwtwUxr0ajEHCQUbXxxNyMfO1wNVW6S1HJ5Fko9o+M+/oG346iNrr6QcxLebi
         qxRXT2TEABhTfJZzz0Ro2H9u3nUdEVXpM0gzSu9GK3aYA+IUJCDDpdhuKYyoPHZpFCgn
         oaO4vF4vz/Ai2rS0CfeetPPUq5ehRIGbYtHtsMsEkg8ul3f8YhcQhOUZqGRAEDeIgC9E
         Ta8w==
X-Gm-Message-State: AOAM532QCh4Ec1QHg73ZdzHmR2O5Ggq3qOgUq+Yw5My+BGEt/EQZACFr
        Uos2y+hOKs2DQdIXgI6cRorSBjNSlKU=
X-Google-Smtp-Source: ABdhPJwmMSY91uJnVjQAOKted98+feaLvKsK3tHGLhDorxMV0kpuM6LigrfL4pM3ha/MCKgEybn8RA==
X-Received: by 2002:a17:907:168a:b0:6da:9167:47dc with SMTP id hc10-20020a170907168a00b006da916747dcmr10407165ejc.126.1651486012229;
        Mon, 02 May 2022 03:06:52 -0700 (PDT)
Received: from crow.. (78-154-13-120.ip.btc-net.bg. [78.154.13.120])
        by smtp.gmail.com with ESMTPSA id ml18-20020a170906cc1200b006f3ef214e42sm3439994ejb.168.2022.05.02.03.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 03:06:51 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3] trace-cruncher: Build trace-obj-debug.c as library
Date:   Mon,  2 May 2022 13:06:41 +0300
Message-Id: <20220502100641.1903517-1-y.karadz@gmail.com>
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

Changes in v3:
 - The name of the library changet to 'libtcrunchbase.so'. Some Makefile
   variables are changed accordingly.

 Makefile | 24 +++++++++++++++++++++---
 setup.py |  4 ++--
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 52428c0..d359ea6 100644
--- a/Makefile
+++ b/Makefile
@@ -13,13 +13,31 @@ NC	:= '\e[0m'
 
 DOCDIR = ./docs
 
-all:
+CC = gcc
+CFLAGS = -fPIC -Wall -Wextra -O2 -g
+LDFLAGS = -shared -lbfd
+RM = rm -rf
+
+TC_BASE_LIB = tracecruncher/libtcrunchbase.so
+PY_SETUP = setup
+
+BASE_SRCS = src/trace-obj-debug.c
+BASE_OBJS = $(BASE_SRCS:.c=.o)
+
+all: $(TC_BASE_LIB) $(PY_SETUP)
 	@ echo ${CYAN}Buildinging trace-cruncher:${NC};
+
+$(PY_SETUP):
 	python3 setup.py build
 
+$(TC_BASE_LIB): $(BASE_OBJS)
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+
 clean:
-	rm -f src/npdatawrapper.c
-	rm -rf build
+	${RM} src/npdatawrapper.c
+	${RM} $(TC_BASE_LIB)
+	${RM} src/*.o
+	${RM} build
 
 install:
 	@ echo ${CYAN}Installing trace-cruncher:${NC};
diff --git a/setup.py b/setup.py
index 58561cf..aca634c 100644
--- a/setup.py
+++ b/setup.py
@@ -37,7 +37,7 @@ def add_library(lib, min_version,
         libs_found.extend([(lib, lib_version)])
 
 def third_party_paths():
-    library_dirs = []
+    library_dirs = ['$ORIGIN','tracecruncher']
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
+          package_data={'tracecruncher': ['*.so']},
           ext_modules=[module_ft, module_data, module_ks],
           classifiers=[
               'Development Status :: 4 - Beta',
-- 
2.32.0

