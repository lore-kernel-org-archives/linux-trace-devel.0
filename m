Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E98C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 06:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiA0GJ7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiA0GJ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 01:09:58 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BD3C061714
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:09:58 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id k25so3464683ejp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UVucL61GOiENp0JQvYBQ2FQczO0d13ot3FxCLvTcZiE=;
        b=FIzjQQcG4uahib7jI0vgAwe5M3o+wakDZxI2nS8fl+gfIfpwb3c0mSApLx8zpOAFEI
         nq9pivliH3fCQexgOewWTYJy2p3k0QLezV76qtG2YJwI8q7QO965uQUUOeAAwaCEk2Vk
         74Fg7T4gMiFyWeQ8pCsp9m31s2GmqeVOCD07XOvNjJetfXD2VGXbWXe67o/uaGe0NOyN
         CtuPEYcuroTeKVY4zMadmwkel0MZJ7gv8T7KwJ/JprQySLaoM2KibWjUI/D2CIO5nd1n
         w2oT8XIggQJn3vzmMIr3OjgIxiHhX/bbshb7krbZOg+qDjCic2GWDuCPrnDKr8ls5Vvy
         lIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UVucL61GOiENp0JQvYBQ2FQczO0d13ot3FxCLvTcZiE=;
        b=7e0uvviwQMDcpquxcb/JAILO535f2pBeVHYVaQRu+DsNoYiMy9H7no0oEhsujAj3so
         Wknyxl8OFl3Sr95j1EN5timQns6YLO7XVoceYExTLFmUjJrtZ0u+66sSn6h41itkSz9+
         KLJYBn/yaUTlslt09IG0hc1ZApoc1QRNmaf2W5NkuDVtcUqYWOpJ9O4/3H52GlFdaj54
         x5+3KkbUrw6FmmZwa8n6k9Jw1QxaEMBWpw4wX0Wl6ObenOLppXJlmp5HPvhE7Hq0J2iR
         +K4CSSa2cCHLprqr3MMDDfXu6loYeRfPSV8vnmNZmURsldQZfnGD7jKNqLZ30w0b2vqo
         +FPQ==
X-Gm-Message-State: AOAM53079XUIB9IjebG2QYRcZX7zuLHqEddZju3SH4S00VhZXZSdX9Nf
        2T/PRJNytPH5il145ZpVIWUAKd39MpI=
X-Google-Smtp-Source: ABdhPJxX4jBbm0K3Fd5QaR18xJjM57Zup7L3h47hWqEchMApcuP+eVauqjT9O7p/GuwfxnvZ6tsRzg==
X-Received: by 2002:a17:906:3602:: with SMTP id q2mr1716876ejb.331.1643263796920;
        Wed, 26 Jan 2022 22:09:56 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t15sm8279846eju.1.2022.01.26.22.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 22:09:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] trace-cruncher: Add support for event probes
Date:   Thu, 27 Jan 2022 08:09:52 +0200
Message-Id: <20220127060954.22927-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Event probe (eprobe) is a new type of ftrace dynamic events, introduced
in the Linux kernel 5.15 version. It is useful to have support for them
in trace-cruncher, as it allows more flexibility when printing event's
data.

v2 changes:
 - Moved unit test in a separate patch.
 - Added a check in the unit test if the kernel supports eprobes.
 - Renamed the API from PyFtrace_register_eprobe() to PyFtrace_eprobe(), for
   consistency with the other dynamic events APIs.

Tzvetomir Stoyanov (VMware) (2):
  trace-cruncher: Add support for event probes
  trace-cruncher: Unit test for event probes API

 src/ftracepy-utils.c                          | 32 ++++++++++++
 src/ftracepy-utils.h                          |  2 +
 src/ftracepy.c                                |  5 ++
 .../tests/1_unit/test_01_ftracepy_unit.py     | 50 +++++++++++++++++++
 4 files changed, 89 insertions(+)

-- 
2.34.1

