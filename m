Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2423AC2BB9A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA9A4205F4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbgLINnz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732623AbgLINnz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:43:55 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07FEC0619D9
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:45 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r14so1810616wrn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o38zang5TtJ9YqUydHJphOaVzBNm5+HcGsgJiHtqfjU=;
        b=OgZvCW9m3skUTgKSBgv6jIsbHcfLnDUieTurfiQmTFQJtIG0n1eHz6OhehxDCXRzci
         TrgGMhObNvwYvmK8mPe62no1P3Nu+PWEgL9PMUAHrce0nm0e4flOTStjwKkK3rJd4bBE
         kaCMRgFQnWMgulATwaEzeg2FL8vQ3EBp85qcNnblWIYbqMSEAr9+OlmrKbjdV46+PPS+
         ZP8I56qQOEWF7SSAukh3G/mXVHtwnBDkV63n49FGy9ebJuIiqhDHUmkAgCodixvxnhcK
         M9zNKiINYW4YZOj9KQxOYD0OSq3xWZuss2sRD096/lm0niYcaqQmsWczCythvMbw1G9H
         uMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o38zang5TtJ9YqUydHJphOaVzBNm5+HcGsgJiHtqfjU=;
        b=bxzjIY9f0DtpcyynI6DCkqNnK/B19SQgHCiYhXGNhZ9XjoBuqmnrqQp5YkhG8dkTHZ
         ronPq8IgK+mceVrS6C6FgmsFGS5dqKnc08DkqS3KxIT0MlHfRAtPtexOJDKSAosM3omm
         TbljBkMAtNz4PIZ/nB/8onU2Uev97m1+SquqNbTfReTKVQUYR9whbsbPLdk0rQoV2tZ9
         1oG3yKoSw2IDjHpuDBA1ar00J+HYzHkJvWImDRRDtIf+ln38UkPRk46QHiUXEilzbrf2
         QzZzJei+CFs/Pc7zLmYzmlMKFqjCaUJzl7/7KZL00pURfswLaM8Sp5DirZHRidlXj6df
         JMeg==
X-Gm-Message-State: AOAM530f+OljBBYF1t18TYOAnerziga7Fx5lNhVx6CHtbKf1LE/ZqAL2
        HK/H6lVmxVoQlYdCJ2FDBYg=
X-Google-Smtp-Source: ABdhPJzMZv8EtTYzcHy0Wgg73I4Uka8SOdx1LSDDUDQ7uwMI0FdSd9rdZHtn+4Frjdjb0xsRpwB3pA==
X-Received: by 2002:adf:9104:: with SMTP id j4mr2957014wrj.198.1607521364479;
        Wed, 09 Dec 2020 05:42:44 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:44 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 27/27] kernel-shark: Add "github Actions" workflow
Date:   Wed,  9 Dec 2020 15:42:03 +0200
Message-Id: <20201209134203.428068-28-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Yordan Karadzhov <y.karadz@gmail.com>

The workflow will install all third party libraries,
will build KernelShark and will run the tests.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .github/workflows/main.yml | 51 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 .github/workflows/main.yml

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
new file mode 100644
index 0000000..a6a8311
--- /dev/null
+++ b/.github/workflows/main.yml
@@ -0,0 +1,51 @@
+name: KernelShark CI (CMAKE)
+
+on: [push]
+
+env:
+  # Customize the CMake build type here (Release, Debug, RelWithDebInfo, etc.)
+  BUILD_TYPE: Release
+
+jobs:
+  build:
+    runs-on: ubuntu-latest
+
+    steps:
+    - uses: actions/checkout@v2
+
+    - name: Install Dependencies
+      shell: bash
+      run: |
+        sudo apt-get install build-essential git cmake libjson-c-dev -y
+        sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
+        sudo apt-get install qtbase5-dev libboost-all-dev -y
+        git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
+        cd trace-cmd
+        make
+        sudo make install_libs
+    - name: Create Build Environment
+      # Some projects don't allow in-source building, so create a separate build directory
+      # We'll use this as our working directory for all subsequent commands
+      run: cmake -E make_directory ${{runner.workspace}}/build
+
+    - name: Configure CMake
+      # Use a bash shell so we can use the same syntax for environment variable
+      # access regardless of the host operating system
+      shell: bash
+      working-directory: ${{runner.workspace}}/build
+      # Note the current convention is to use the -S and -B options here to specify source
+      # and build directories, but this is only available with CMake 3.13 and higher.
+      # The CMake binaries on the Github Actions machines are (as of this writing) 3.12
+      run: cmake $GITHUB_WORKSPACE -DCMAKE_BUILD_TYPE=$BUILD_TYPE
+
+    - name: Build
+      working-directory: ${{runner.workspace}}/build
+      shell: bash
+      # Execute the build.  You can specify a specific target with "--target <NAME>"
+      run: cmake --build . --config $BUILD_TYPE
+
+    - name: Test
+      working-directory: ${{runner.workspace}}/build
+      shell: bash
+      # Execute tests defined by the CMake configuration.
+      run: ctest -C $BUILD_TYPE
-- 
2.25.1

