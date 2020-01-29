Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D5AC33CB2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C562A20708
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9S36A6i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgA2JyZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:25 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:44413 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2JyZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:25 -0500
Received: by mail-lj1-f181.google.com with SMTP id q8so17698342ljj.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xIum2rKl9q4t3jmOsjzfhfIX8s8KIg3Hwe46szfm3t8=;
        b=i9S36A6i7kWlj/xskoBU38EXYGHpH58NSCYxWrFAGoOG32oSXGBOzLdnbGc7GhYMtN
         J9Xh/aCAMLIjPnjS6kefzUp7n9LzXTERWiwQOB3GiNPOKaeI2i61UbC1FzO46lL+i0HU
         CLkpzLBMaN2Dj4JXAF6jkaBT8fKzQxn+8SQK9crT9ILhFxlPY58S7Yrygh+lQbDuGXx2
         fse4fsapCac2tbu6MlptbA6tVKqgkdw0elx6gZRJ4f/d54S3me6cSsozVHWheBsL0PRF
         pov28h+utbQ68gES3hMl6444DzyaR9O4dJX6bNOQPhVkodOwL/98igIRfjuxZHCacLSm
         ZX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xIum2rKl9q4t3jmOsjzfhfIX8s8KIg3Hwe46szfm3t8=;
        b=D/cNVMwcfqrR1RoceehL+TfVIxAP4L9gujrpVt5vwEUvqx/UUVWHAhqwEKLd0UJTiD
         j+jj+u1VemWBMBJfIvkFmlNjLpdFPLQqLPrKYf1RS6t+mojy62tdOn0JHXf+Wxr1PgE9
         bo77sfKJhUmh+5+Jr9MtLag1IiPNVLKcSFkBj0Vjx3ZJ9ApwRaMQ1VUt5Cly4wVXJ0Tv
         ZmfEzH81mQuhr9moYv0LlwPDFudpcfn6/H0UPbRYEniXKiFT5Z7vVoE5oxuuIvt7Wk4O
         +gLfZWCXA8b/Y99B2B2V81eBNgMnMuYG164WaO53JwKMULcuUgGBE/vYH+2NN7c9UJ49
         mLxw==
X-Gm-Message-State: APjAAAWh1jsjNn2WhxtvXFFEtJ7NmIYqmSm5/SYxkZMiMQUc7FigMUhB
        D6FAlquc2ws7OWhZPI1A/Lu15I50
X-Google-Smtp-Source: APXvYqw/x6hg/FzwNAnU9gPLaGRBXrrrgonD8ynBZaR1OCTTj+wRHGnyYipFcJ/2dUKbXqWGHEc+qQ==
X-Received: by 2002:a2e:9d0f:: with SMTP id t15mr15719711lji.171.1580291663384;
        Wed, 29 Jan 2020 01:54:23 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/9] libtracefs: few fixes and a lot of unit tests
Date:   Wed, 29 Jan 2020 11:54:12 +0200
Message-Id: <20200129095421.881786-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Few minor libtracefs fixes and a lot of new unit tests,
covering all library APIs.

Tzvetomir Stoyanov (VMware) (9):
  trace-cmd: fix description of tracefs_get_tracing_dir() API
  trace-cmd: Remove tracefs_read_page_record() API
  trace-cmd: Add sanity check of tracefs_get_tracing_file() input
    parameter.
  trace-cmd: Unit test for libtracefs
  trace-cmd: Unit tests for libtracefs APIs related to tracing file /
    directory
  trace-cmd: Unit tests for libtracefs APIs related to ftrace instances
  trace-cmd: Unit tests for libtracefs APIs related to ftrace events and
    systems
  trace-cmd: Unit test for tracefs_tracers() API
  trace-cmd: Unit tests for libtracefs APIs related to allocating a tep
    handler based on local events

 Makefile                    |  13 +-
 include/tracefs/tracefs.h   |   3 -
 lib/tracefs/tracefs-utils.c |   5 +-
 utest/Makefile              |  41 +++
 utest/README                |  15 ++
 utest/trace-utest.c         |  83 ++++++
 utest/trace-utest.h         |  11 +
 utest/tracefs-utest.c       | 491 ++++++++++++++++++++++++++++++++++++
 8 files changed, 656 insertions(+), 6 deletions(-)
 create mode 100644 utest/Makefile
 create mode 100644 utest/README
 create mode 100644 utest/trace-utest.c
 create mode 100644 utest/trace-utest.h
 create mode 100644 utest/tracefs-utest.c

-- 
2.24.1

