Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395D8C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 15:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058F5218A1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 15:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfCOPde (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:33:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52997 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfCOPde (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 11:33:34 -0400
Received: by mail-wm1-f66.google.com with SMTP id f65so6930726wma.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 08:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtlrwvYQUlMds6cjjegKcGny8jGvPx/WsqM+qAiRCaw=;
        b=WAaAr5eE5SD4dsYV6GbkKrYVx+jRVZ2aPIWeyjHhF6zCqHRWXKx6pt6xXE/pTpGsEO
         3isFRQS4+BZTToSWzvxll8jU4lhb90qfw4xM9GLuQrZhA/sajcfmcfMzUnUYRMKPeJvh
         JzwJlMe44UOtZPD1QVaUtzfROrpZurRLOaZgLzC3YLeZWH5qEPF7ksG0BFmjYHmaelks
         mBAm14Hq2QQhVNVF4HGezFFct/MLIfyC5VWiUCkp46eX3+Yk6nHEmpajgZCs7fuS0rGt
         Y7Cwk1EIJ6dJXO+bOmE3eNmxCnbB/84uyFogl4G0Kt2Sju4flvG12mJJH/YFtuU+NIOf
         IOfw==
X-Gm-Message-State: APjAAAXrsMMWIowJ6U14nuk+07m3aD3OHFrKChEbHB/fyaxHGoSbUUGZ
        RWcp9ZgPX8mp/hzFYG9X5A==
X-Google-Smtp-Source: APXvYqzhHtWQj9KRZuoZAQOB5vib/2P7fKpgr/D2roimx4XqSxY6/ZOyrsnaaJGiSc909oqTFHiPVg==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr2516729wml.4.1552664012911;
        Fri, 15 Mar 2019 08:33:32 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a204sm2654221wmf.12.2019.03.15.08.33.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 08:33:31 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH 0/3] Switch V3 messages to text encoding of variable length buffer
Date:   Fri, 15 Mar 2019 17:33:23 +0200
Message-Id: <20190315153326.5602-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset switches protocol V3 messages to use text encoding for the
variable length buffer at the end as Steven suggested.

Slavomir Kaslev (3):
  trace-cmd: Use text encoding for options in protocol V3
  trace-cmd: Use text encoding for transmitting ports in protocol V3
  trace-cmd: Add msg_buf_len() function

 tracecmd/trace-msg.c | 166 ++++++++++++++++++++++++++-----------------
 1 file changed, 99 insertions(+), 67 deletions(-)

-- 
2.19.1

