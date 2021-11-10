Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F1FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A69466121F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhKJOlA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhKJOlA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 09:41:00 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A861C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:12 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b15so11290779edd.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tbed0ZzCbfH/NFZk+qckJsMKE+1UI6IMMi6vOu2wbcw=;
        b=AUyFTAw2CMSd20nMAhwtSslhdffGsck6kodMDdsiIErVEEZlb2ehkHwYjGAXZU1oJu
         HlyowT0bfaiHyZrwvGU4tmyP3hdFX+3HnPbT4txR8WpVDBRUERXcDZfa8D3JbEQ7YsHy
         WSE6IuzPwWVZcBaaoGBWkj52N6GUhOb6EYS4Vc26o9/ZKbRLYDYPToIxjh78BFgzFOsL
         GNNh4zJGsDm5DvzRe5ySMzaKu2AgMW3lxBGPrTEPdc96EDurBW4ehAKfDMmf97H7m7fD
         z9vjhAG5+vm95PCYqnnrQsTAdRLD3mS8LwNlMgm+1TeOLmk/hfNrg5tYC2Q1ASUFOVPY
         b/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tbed0ZzCbfH/NFZk+qckJsMKE+1UI6IMMi6vOu2wbcw=;
        b=WO3pn9no5C3rmS5nqUU9+8sZkIokChOhL3hPCQ4dTio28CiFsO2sEgK+3IXWpLi8Io
         NpCnPNfEJNFaMtOK1qB4B+Yh8IYCVLJHFKV+4FrMr4Yz0qswLc7sbTZ3JTEx1rHhT+PH
         28Z88Wc/yrNc14EdY0d9QU54IDTxVnu6PNQisp84nG0sfS1uVe7i3xV02MsBdZsK6V3g
         ZbhPwSJS/noVqa3rd0yIrU4a6MtICSRW10EVeEJYzWbdsPc+0DwL65HIkZHWk9SDNZaM
         VcSVkeec2jeUygG3hojs/rP+CKz+snppXF8WJA5tXJyZPSq9MwKA4fhlMG9EWAWqh+T6
         1faw==
X-Gm-Message-State: AOAM532BlIxtqMYRw1F7UnkomGB47kwY234+9PtMDMyXXkeNT54uSffo
        oVPuF7JD7tOtFg9Y2k/JAt3TvTM3LHc=
X-Google-Smtp-Source: ABdhPJwae0MWFHYLLcanE5mreNJ41MRfG5BD0AGDnhPkO5GYjaAZoYl5+quwgQpG2hqigfA68kZrlg==
X-Received: by 2002:a05:6402:1908:: with SMTP id e8mr57349edz.83.1636555090877;
        Wed, 10 Nov 2021 06:38:10 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id hc10sm11477039ejc.99.2021.11.10.06.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:38:10 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/5] kernel-shark: Update the README file
Date:   Wed, 10 Nov 2021 16:37:45 +0200
Message-Id: <20211110143747.32833-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110143747.32833-1-y.karadz@gmail.com>
References: <20211110143747.32833-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Making sure that the install instructions are adequate for building
with the latest versions of the third-party libraries.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 README | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/README b/README
index 652891c..24d6001 100644
--- a/README
+++ b/README
@@ -13,7 +13,8 @@ KernelShark has the following external dependencies:
 1. In order to install the packages on Ubuntu do the following:
     sudo apt-get install build-essential git cmake libjson-c-dev -y
     sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
-    sudo apt-get install fonts-freefont-ttf
+    sudo apt-get install flex bison -y
+    sudo apt-get install fonts-freefont-ttf -y
     sudo apt-get install qtbase5-dev -y
 
 1.1 If you want to be able to generate Doxygen documentation:
@@ -21,12 +22,14 @@ KernelShark has the following external dependencies:
 
 
 2. In order to install the packages on Fedora, as root do the following:
-    dnf install gcc gcc-c++ git cmake json-c-devel -y
-    dnf install freeglut-devel redhat-rpm-config -y
-    dnf install qt5-qtbase-devel -y
+    sudo dnf install gcc gcc-c++ git cmake json-c-devel -y
+    sudo dnf install freeglut-devel redhat-rpm-config -y
+    sudo dnf install flex bison -y
+    sudo dnf install gnu-free-sans-fonts -y
+    sudo dnf install qt5-qtbase-devel -y
 
 2.1 If you want to be able to generate Doxygen documentation:
-    dnf install graphviz doxygen -y
+    sudo dnf install graphviz doxygen -y
 
 
 3. In order to install the final dependencies do the following:
@@ -43,6 +46,8 @@ KernelShark has the following external dependencies:
     git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
     cd trace-cmd
     make
+    make libs
+    sudo make install
     sudo make install_libs
 
 Building:
-- 
2.33.1

