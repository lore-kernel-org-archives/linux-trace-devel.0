Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9A6C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBB1520989
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:02:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="NLUaL4FH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfEJVCx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 17:02:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37992 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbfEJVCx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 17:02:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id a59so3366691pla.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 May 2019 14:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DSM9QnrDKXAguebkTcIHZr34hOXCazJ7jbiMS3sjFG0=;
        b=NLUaL4FHFVO2XZ1o5FiA591+OqnxOBnSqbPXObMPFh0sBANyhKWyCFLl+BFqyewWEz
         Pqez3RXkqGor24LQnV4Lwbn047iq4G+8z5FUU7/RLAcMGdCj9msWknntyfj1/Xo41a4y
         c7ECDM7JnkwFg3scDraci1UqQQ7O/7Gaha4fQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DSM9QnrDKXAguebkTcIHZr34hOXCazJ7jbiMS3sjFG0=;
        b=LRMuLFCkn2ywFFBI8CnL9JvMu9Vq09cW4qqa/aXx0gY4FlyO9slpF5EUQXW5LLXJ8Z
         XTVYhiqbDDvd/yspLLAwPf6VdiS2oRYYoDZ7SvWQ6B7hWrkAMunfA5lqma5nuv6nq15Q
         9g+qnGlcoSlQ54ogIFwaGGdK+0BVmvZeOD2dg9XA1rCwj2HymW7LWyPU4EcmyTA0Rvko
         eP8FM46sMkjQ+WpoJU23OuVhY0MWbyckLQ6UCafTXjUM9U9ENisoUn09X9QSYbIvpiCu
         7JoLm3xSd6OuXBG3guf5aVIAEMY300a4rvEue181GMKlvO0b7Th4tJQreH7PNuYIwy24
         xRMA==
X-Gm-Message-State: APjAAAUCZND4eY/fzqRUOrctf8vT256rNdKt5uPs82Vz2DHwCuRRz9BK
        5Xxj0TiTuy2C6fCg98JqjlBKlQ==
X-Google-Smtp-Source: APXvYqzFRosXWlE/0OD5jjgi4bX4YKhF9JmgF8D58Nbp+0mwQId0lGZmoxC0ixR3Q1C5A8ZPoiqHyA==
X-Received: by 2002:a17:902:b108:: with SMTP id q8mr10473611plr.110.1557522172297;
        Fri, 10 May 2019 14:02:52 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id y8sm6523333pgk.20.2019.05.10.14.02.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 10 May 2019 14:02:50 -0700 (PDT)
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
Subject: [PATCH 0/3] kheaders fixes for -rc
Date:   Fri, 10 May 2019 17:02:40 -0400
Message-Id: <20190510210243.152808-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Linus, Greg, Masahiro,
Here are some simple fixes for the kheaders feature. Please consider these
patches for an rc release. They are based on Linus's master branch. Thanks!

Joel Fernandes (Google) (3):
kheaders: Move from proc to sysfs
kheaders: Do not regenerate archive if config is not changed
kheaders: Make it depend on sysfs

init/Kconfig                                | 17 +++++----
kernel/Makefile                             |  4 +--
kernel/{gen_ikh_data.sh => gen_kheaders.sh} | 17 ++++++---
kernel/kheaders.c                           | 40 +++++++++------------
4 files changed, 38 insertions(+), 40 deletions(-)
rename kernel/{gen_ikh_data.sh => gen_kheaders.sh} (82%)

--
2.21.0.1020.gf2820cf01a-goog

