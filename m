Return-Path: <SRS0=wRMB=UQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B95BC31E57
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 11:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D38E2084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 11:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rSASzUI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbfFQLwW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 07:52:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46292 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfFQLwV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 07:52:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so9580773wrw.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jun 2019 04:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zB+Hv/wJUBc2lA063hQE1Bz6AYsMmwDkqQHQQ2hdK9I=;
        b=rSASzUI8qpV4qP1nuYEuEBB8czmVRkL0l4IojbP5jT2XkXY1YaaSuwOZmH+sJ6593J
         s0onYzhSUriLSX6hUUDFzqIhH+bCbKAh//3tZ2w38OyD0bsfcxN0npEfelmUZCpcr9r1
         vAy4IWIOkU6tRnEO9WhNGKj8afuczKMVJWy4oUkjMOeFKsKVmTDTgs+VMWGZAUJ0q6kh
         KJVzIQ3AjimCWY/3f3IpEeer3tSxPChGU1ZnMpuRE/dOk2VJuU5XAhxtTBtI1PZXdFQc
         RU5ig0U87nHn1Vn6KTye2KLWIo0EwGBwbScM6/RIJI1WpJhBo2NdKtnwi6/LPCxMnzIE
         lOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zB+Hv/wJUBc2lA063hQE1Bz6AYsMmwDkqQHQQ2hdK9I=;
        b=dOFKJBneBn1H/OSr7BDKovbYFP1wLL/UVTSrf2PzlvoWvFJfHK3mVZIgMm7T3p9PTi
         b+oGAWc9eBPZFpdSsz6zdj4akstJiqyywbetzrYywOuBMq149soCOJF9OpxJSGkw97UV
         gP7JWREQk4QAuWgkWfhCsdjpzauxb3crpyHQZqSY3hDGZt7wz1rgnD8NeRobp4WS0Npt
         VyfJBbTuqbTM30qS/shhYcyKOlTH1z8UFOToHmuK5hF3f471zuxo5xx05pAi1jKPJ2iK
         9kGsR3DORrZDOvvZLDFapimuG/BrrrPC4QrW0mJtfMSLs3TV86r4j7acbB/X9dPFnieF
         jCrw==
X-Gm-Message-State: APjAAAVPjf32pBDiRNVtX5H9ZUtUqULQFF+mA6+QHjEA+T21i1sq+5de
        5Gbdi9l0JiuNWW9ukbu5OZc=
X-Google-Smtp-Source: APXvYqxi4t2qdlI8+ENzJ/jgNQ7g0JTxMd6QBuBftVe3CH/4YQltwc9N/z4tX/HChMLqy15fS4i2FA==
X-Received: by 2002:adf:f951:: with SMTP id q17mr48647750wrr.173.1560772340559;
        Mon, 17 Jun 2019 04:52:20 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d18sm13332040wrb.90.2019.06.17.04.52.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 04:52:19 -0700 (PDT)
From:   tz.stoyanov@gmail.com
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Save tracee memory map into trace.dat file
Date:   Mon, 17 Jun 2019 14:52:16 +0300
Message-Id: <20190617115218.6279-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

New trace-cmd option is introduced, "--mmap". When it is used together
with -F or -P options, the memory map of the traced applications is
stored into the trace.dat file. The new API tracecmd_search_tracee_mmap()
can be used to do lookups into those memory maps.


Tzvetomir Stoyanov (1):
  trace-cmd: Implemented new API tracecmd_add_option_v()

Tzvetomir Stoyanov (VMware) (1):
  trace-cmd: Save the tracee memory map into the trace.dat file.

 include/trace-cmd/trace-cmd.h    |   9 +++
 include/traceevent/event-parse.h |   1 +
 lib/trace-cmd/trace-input.c      |  81 ++++++++++++++++++++
 tracecmd/include/trace-local.h   |  16 ++++
 tracecmd/trace-output.c          | 117 ++++++++++++++++++++++++-----
 tracecmd/trace-record.c          | 123 +++++++++++++++++++++++++++++++
 6 files changed, 330 insertions(+), 17 deletions(-)

-- 
2.21.0

