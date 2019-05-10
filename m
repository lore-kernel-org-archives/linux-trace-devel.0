Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E557C46460
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DC072182B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="D9SGlVo7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfEJVDE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 17:03:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39953 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbfEJVDE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 17:03:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id d31so3563300pgl.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 May 2019 14:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zjB9LsovF8lpor6w+CVg9dpdpQizlQADdXWnWKh0+Rg=;
        b=D9SGlVo7Ck++vUgsqaKCetHOTba4eXxwBJsMn3w97aLNbUgfrUym6eZH5nWBabzQU+
         bJDdNUxEktiLHBSD01aT4b7MJ79S8DC5r3msDBA5w4Z2KGcMKKFUBTCzOlK/B6ZdAz6L
         3yZiCCGHiItEXH8/4KAuTTq0FR/DHlAqHa4LM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zjB9LsovF8lpor6w+CVg9dpdpQizlQADdXWnWKh0+Rg=;
        b=IdbWVipCVSRwTvcX/ptDC1AOwefcVXbnuAoGBl/eAQUBOUs4GLceje61OGcLv0CmNM
         0J5cLugzDFdf/+GbE4xGKtBl6QdofGPkfWu8IIMJ4XMbE5CjIAd5pjsBAHyMRD3MNWuc
         JHWKbrCF664TBbUeClfnIT0vo3h9suRkkwoXnHQ3m+qqK258DgNhm6BqF3q6q5scrUw8
         cjZo9c7VSwArHMxb1V5j3/+5ZJbwYR7BWYXkFqz5J/bVm73Ct5yTbLHRVJM30apx07Rd
         ywbwh75RRcVNJcw6nvoc31j8KhnWG5InZSH+a9y8uyumB5+Rm9tahgds/aWfHFiJuEnP
         PwnA==
X-Gm-Message-State: APjAAAUi8emR4jTlvOYm6OHEWGJgmGWgOR3AtJUX7/aYV48MeOsD6ATq
        WF13UMOJPCJlhyn4W1kj8cnitA==
X-Google-Smtp-Source: APXvYqwU/uIecHFUVATLCO4RFIu+l81mTNnwtJnQxKy3rwJUU8eEXNHuGZuMJKQAC5NWdvLcmGiz8A==
X-Received: by 2002:a62:470e:: with SMTP id u14mr17205590pfa.31.1557522183583;
        Fri, 10 May 2019 14:03:03 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id y8sm6523333pgk.20.2019.05.10.14.02.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 10 May 2019 14:03:02 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, atishp04@gmail.com,
        bpf@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, dancol@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, duyuchao <yuchao.du@unisoc.com>,
        gregkh@linuxfoundation.org, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        =?UTF-8?q?Micha=C5=82=20Gregorczyk?= <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>,
        Olof Johansson <olof@lixom.net>, qais.yousef@arm.com,
        rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>, yhs@fb.com
Subject: [PATCH 2/3] kheaders: Do not regenerate archive if config is not changed
Date:   Fri, 10 May 2019 17:02:42 -0400
Message-Id: <20190510210243.152808-3-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190510210243.152808-1-joel@joelfernandes.org>
References: <20190510210243.152808-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Linus reported an issue that doing an allmodconfig was causing the
kheaders archive to be regenerated even though the config is the same.
This patch fixes the issue by ignoring the config-related header files
for "knowing when to regenerate based on timestamps".  Instead, if the
CONFIG_X_Y option really changes, then we there are the
include/config/X/Y.h which will already tells us "if a config really
changed". So we don't really need these files for regeneration detection
anyway, and ignoring them fixes Linus's issue.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/gen_kheaders.sh | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index 581b83534587..9a34e1d9bd7f 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -31,9 +31,8 @@ arch/$SRCARCH/include/
 
 # This block is useful for debugging the incremental builds.
 # Uncomment it for debugging.
-# iter=1
-# if [ ! -f /tmp/iter ]; then echo 1 > /tmp/iter;
-# else; 	iter=$(($(cat /tmp/iter) + 1)); fi
+# if [ ! -f /tmp/iter ]; then iter=1; echo 1 > /tmp/iter;
+# else iter=$(($(cat /tmp/iter) + 1)); echo $iter > /tmp/iter; fi
 # find $src_file_list -type f | xargs ls -lR > /tmp/src-ls-$iter
 # find $obj_file_list -type f | xargs ls -lR > /tmp/obj-ls-$iter
 
@@ -43,10 +42,18 @@ arch/$SRCARCH/include/
 pushd $kroot > /dev/null
 src_files_md5="$(find $src_file_list -type f                       |
 		grep -v "include/generated/compile.h"		   |
+		grep -v "include/generated/autoconf.h"		   |
+		grep -v "include/config/auto.conf"		   |
+		grep -v "include/config/auto.conf.cmd"		   |
+		grep -v "include/config/tristate.conf"		   |
 		xargs ls -lR | md5sum | cut -d ' ' -f1)"
 popd > /dev/null
 obj_files_md5="$(find $obj_file_list -type f                       |
 		grep -v "include/generated/compile.h"		   |
+		grep -v "include/generated/autoconf.h"		   |
+		grep -v "include/config/auto.conf"                 |
+		grep -v "include/config/auto.conf.cmd"		   |
+		grep -v "include/config/tristate.conf"		   |
 		xargs ls -lR | md5sum | cut -d ' ' -f1)"
 
 if [ -f $tarfile ]; then tarfile_md5="$(md5sum $tarfile | cut -d ' ' -f1)"; fi
@@ -82,7 +89,7 @@ find $cpio_dir -type f -print0 |
 
 tar -Jcf $tarfile -C $cpio_dir/ . > /dev/null
 
-echo "$src_files_md5" > kernel/kheaders.md5
+echo "$src_files_md5" >  kernel/kheaders.md5
 echo "$obj_files_md5" >> kernel/kheaders.md5
 echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
 
-- 
2.21.0.1020.gf2820cf01a-goog

