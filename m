Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305CAC04AB3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F39E621841
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="UVBj/OwF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfEJVDJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 17:03:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41565 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728069AbfEJVDI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 17:03:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id l132so3828916pfc.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 May 2019 14:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g9Gow6vM42aJp56wjf9r7GBUU79udYOMt8dacDWI13Q=;
        b=UVBj/OwFLiTzum6IDgk7LUVfg4GiBlqfYvJJl4E6HY2WxlnZ0tj+8Mbyp8HNH5SRIF
         xlPqFSE4NCYZBHfO7irbMEN+Vg+YxVQx3scJ2UAuP3Tk7DRfDauHCWrKS0qfq1K4r+C8
         3DBrBuEM2rpf+Pk1qNBmlldbVkgMKr/w1GTH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g9Gow6vM42aJp56wjf9r7GBUU79udYOMt8dacDWI13Q=;
        b=loDtfzILXScAZC9Sa+c5/fF/uQJuWBKy90OjFEs0vzx5HAsv/+pizfg4HaErnjKn2n
         QeV4UbzYxQ8W/+fACpuaJFTML8s1Y/7MDtbqPcK3uQpW/yLni+A+aGUG/REVOiwUGfPq
         nWEOI8aML/SrxWlChybZ0nvc08uBad6+iZUs/Qu7qty2WDQBdIi/LfeiS6XZkh5qxbkg
         Aa/CuX6RLlPD8qy3EKRPLcAW7O4nETSeNHm4RC9bTHBG+NTDWhjD97c6BmVePFGqbcKe
         N7XoZrzgX/yePjGmpZ+thzbT6lqgtfTY15kbE+5tD/DlLh022BUO6DV8lmpZsAMP8OW7
         DE3A==
X-Gm-Message-State: APjAAAXSD+anIECbwvGQjT/5W4dx8P2+kBgCtLXrzSNyC76nzBSrh+v5
        J4FETsCwUK6obXTg9S8J8QROFQ==
X-Google-Smtp-Source: APXvYqxx7K5CBGqKQ/c/VTttlOFyb3tvfg/8U27VnQPYkICRqEywBVXgF7yTbE4iu6TL2YhtYXVtAQ==
X-Received: by 2002:a63:2118:: with SMTP id h24mr16498738pgh.320.1557522187805;
        Fri, 10 May 2019 14:03:07 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id y8sm6523333pgk.20.2019.05.10.14.03.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 10 May 2019 14:03:06 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
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
        Masami Hiramatsu <mhiramat@kernel.org>,
        =?UTF-8?q?Micha=C5=82=20Gregorczyk?= <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>,
        Olof Johansson <olof@lixom.net>, qais.yousef@arm.com,
        rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>, yhs@fb.com
Subject: [PATCH 3/3] kheaders: Make it depend on sysfs
Date:   Fri, 10 May 2019 17:02:43 -0400
Message-Id: <20190510210243.152808-4-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190510210243.152808-1-joel@joelfernandes.org>
References: <20190510210243.152808-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The kheaders archive is exposed through SYSFS in /sys/kernel/. Make it
depend on SYSFS as it makes no sense to enable this feature without it.

Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index ce08adf0f637..f27138a8cf28 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -581,6 +581,7 @@ config IKCONFIG_PROC
 
 config IKHEADERS
 	tristate "Enable kernel headers through /sys/kernel/kheaders.tar.xz"
+	depends on SYSFS
 	help
 	  This option enables access to the in-kernel headers that are generated during
 	  the build process. These can be used to build eBPF tracing programs,
-- 
2.21.0.1020.gf2820cf01a-goog

