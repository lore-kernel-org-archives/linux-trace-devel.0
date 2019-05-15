Return-Path: <SRS0=5FCK=TP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1CDC46460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 21:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F07421473
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 21:36:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="pLODJpLN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfEOVgG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 May 2019 17:36:06 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42271 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfEOVgG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 May 2019 17:36:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id 13so628790pfw.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 May 2019 14:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lj20BWGa/SSqkCUWhiNbUp+2jcIFFr5rWtfoPrCsSoQ=;
        b=pLODJpLNTPnjKZE6jiCeKVcXugMyLtlONq+lmg6tPOtTzJj46GJOU6Cf+nCpBKO8Gl
         QuPx22/EvuL7Mr6XG7dpT5RWwvPsfXc8SjNKuFgXNwGZ+VH8P/PM3RgZU3YOnnasoalh
         bPKxFuh4a8fB5IVVNP9Jhftas1hXtKt5gUvik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lj20BWGa/SSqkCUWhiNbUp+2jcIFFr5rWtfoPrCsSoQ=;
        b=TvBQGqHtPh2izLeKA1MkhA0vQ49r9pBVJvLjPIyfpZjcAEinNPWZn9wxN8j0COzXXE
         PlkG09pZ86CP6P//t2lkIeI8MPaLh48ogP1Kcj38oXWfbrUdpISfUecYHAq0Z379WJ5E
         IaWuDqQ8lvq4dIVemhw1M027fW5L7oClWskfFsGUGjCECJiJB9YWTjR+4viUW03rQhNW
         57zdENnjw5xXH8/9hv01SFd1J6z0r8AOLvqicbXYlzC4YRY95tz6zofnEjS1BJ41F727
         j7L2UUqY+l0hAL8//+z3AXHK1TYWvOq2fFhkSR0iCnLRTeO+JTvlKd0g0/bZ4DZmYd/a
         m32w==
X-Gm-Message-State: APjAAAVXNqVyNtGmgigcORf0N6Vpp6pvKVsI7E0bSIeorjmqshVFNb9B
        3/ren5Bdu+DNDptXUO3aQtNtgA==
X-Google-Smtp-Source: APXvYqyBnOgRxt8JiSmMw1XdoLOfLDNy0r57NqMlPQGJOPaLskNz2bSXh1R4oaRAS8sq2GtwOuxxpQ==
X-Received: by 2002:a63:f410:: with SMTP id g16mr15243189pgi.428.1557956165115;
        Wed, 15 May 2019 14:36:05 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id q4sm3695279pgb.39.2019.05.15.14.36.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 15 May 2019 14:36:03 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
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
Subject: [PATCH v4 0/2] kheaders fixes for -rc
Date:   Wed, 15 May 2019 17:35:50 -0400
Message-Id: <20190515213552.203737-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Linus, Greg, Masahiro, Here are some simple fixes for the kheaders feature.
Please consider these patches for an rc release. They are based on Linus's
master branch. The only difference between the last series [1] and this one is
I squashed 1/3 and 3/3 and rebased.  Thanks!

[1] https://patchwork.kernel.org/cover/10939557/

Joel Fernandes (Google) (2):
kheaders: Move from proc to sysfs
kheaders: Do not regenerate archive if config is not changed

init/Kconfig                                | 17 +++++----
kernel/Makefile                             |  4 +--
kernel/{gen_ikh_data.sh => gen_kheaders.sh} | 17 ++++++---
kernel/kheaders.c                           | 40 +++++++++------------
4 files changed, 38 insertions(+), 40 deletions(-)
rename kernel/{gen_ikh_data.sh => gen_kheaders.sh} (82%)

--
2.21.0.1020.gf2820cf01a-goog

