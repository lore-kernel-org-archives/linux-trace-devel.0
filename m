Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8839BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Apr 2022 13:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359695AbiD2NWX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Apr 2022 09:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiD2NWW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Apr 2022 09:22:22 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093F7B6D39
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Apr 2022 06:19:01 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a21so9063811edb.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Apr 2022 06:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=06W44tuDA9FZvXgHBceXqUoVu/LraRWtcVBf1tP4+LU=;
        b=TX2qwqWNiHv9P6dYPUk5J6Doj6EV7xB7nZapn9eM0qXsCTqcqQ+WGNFiZ92SB6cpxw
         44knCPAqP4+UO3Z2Qxp5NQLcXtiGZUTtHP3NYblAHxCLLwqGTwkHYZJjShTZStLHtPmI
         +hH0XC8MX9tBsZPLGnzqBf+GgNKdis8UrRvH/FSkm3dNED9vn9x2MoI3odc8hrfsikOa
         L9VtVg4pBZR9+Ec60b9e/Z0+fWSNBMU1Kn/M0pshDzMhOfs1t7ux2Fl9nRoX5nf5BaWp
         7RzBKsTuIejC55440ghp0f2FRG3rLVvW4mP0sWKcyXWewvI1Zq8JzQU/bdroD8i0Qzxl
         n87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=06W44tuDA9FZvXgHBceXqUoVu/LraRWtcVBf1tP4+LU=;
        b=fSeNUEo2rzpei7jCmqzHxds7ImqRVZMG9zv3U+N9i9eXehLlGZDnvaOWtKml+oAlGG
         RQbSbj/qzClsx8FdFIr/bqqEPLr8LbRaxfnq0UrWryKqeVBBtZPA1ykevzcScRr7uZyZ
         V5sfVbK6zqdtkHoF91h4Pqgdhju03G+u4g55ns2QRBqwqNKKXIvRXwxKev7c9N/kbOOf
         jNrPyo8SF8VCLkAXm//dkK9wVtimwc8LrRqQCakS0GLSkTCBrxA+Xza53ftOROTCT7bt
         5/FJobufrWGEIHI2sW4wdhb49qZgEdNi+yHoTPUBQ1FH95yGBF8KKZ1hN7LLWniModJD
         OGow==
X-Gm-Message-State: AOAM532hENpK2oAb3N9RUghYOsh4JHjKoIpRUVzwlgzrvUtX/nsW0Eyd
        D8mG/MgR+dc7SBYezHseHtXsECzELMg=
X-Google-Smtp-Source: ABdhPJwWyJ9w1Sr8lBILmyE6XyqnoqjrxxF2+bI3ADTDHnNkM0Hw0WRwZKXMYN2B1Q4wW2EOTwGlzA==
X-Received: by 2002:a05:6402:2788:b0:426:18e3:b6f9 with SMTP id b8-20020a056402278800b0042618e3b6f9mr13130824ede.81.1651238339306;
        Fri, 29 Apr 2022 06:18:59 -0700 (PDT)
Received: from crow.. (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id yo1-20020a170907136100b006f3ef214e0dsm642794ejb.115.2022.04.29.06.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 06:18:58 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH] trace-cruncher: Build trace-obj-debug.c as library
Date:   Fri, 29 Apr 2022 16:18:46 +0300
Message-Id: <20220429131846.1707745-1-y.karadz@gmail.com>
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

 Makefile | 24 +++++++++++++++++++++---
 setup.py |  3 ++-
 2 files changed, 23 insertions(+), 4 deletions(-)

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
index 58561cf..3c3d40b 100644
--- a/setup.py
+++ b/setup.py
@@ -37,7 +37,7 @@ def add_library(lib, min_version,
         libs_found.extend([(lib, lib_version)])
 
 def third_party_paths():
-    library_dirs = []
+    library_dirs = ['tracecruncher']
     include_dirs = [np.get_include()]
     libs_required = [('libtraceevent', '1.5.0'),
                      ('libtracefs',    '1.3.0'),
@@ -91,6 +91,7 @@ def main():
           url='https://github.com/vmware/trace-cruncher',
           license='LGPL-2.1',
           packages=find_packages(),
+          package_data={'tracecruncher': ['libobjdebug.so']},
           ext_modules=[module_ft, module_data, module_ks],
           classifiers=[
               'Development Status :: 4 - Beta',
-- 
2.32.0

