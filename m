Return-Path: <SRS0=sUNk=X2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535C1ECE587
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 14:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27E6E215EA
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 14:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jp9xiZso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389342AbfJAO5p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 10:57:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47027 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389329AbfJAO5p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 10:57:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so15896044wrv.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Oct 2019 07:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ugGzxVs1bAi/oprVuSwRR0/ssqohRpVbpOxo/iYuPGU=;
        b=Jp9xiZsoyV0NOPjoPq1BeOSqVdHqTaw3su+fYW7pEW97B4YJQZxuARIJhPgZAaTJ+n
         BzOCapat9besmJ9UWc06bJcMTJ6ngQObFP60pl65nWC/6aLNTcOy9j/M+2Aovnf0NgHV
         SVILvw7tS64WVIo+f7ww6vCgCRNkQdf4ry1GO8E7RuYH1TY+z4+e7q3iXbxWYbQYyx/7
         e0D7XRpW+yT7t1OvbKktEDr0EmDK7cY+gg5MaPQZDIsLFhUyYTB53qO5iMF+FoFBoy/0
         SzhZ1s5EB2Oa0/3e5fm/URu0gLHjyYIelYGgZy5Lo0ik88eaGLD9+Y2SkYKGGHFt/NVB
         3gTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ugGzxVs1bAi/oprVuSwRR0/ssqohRpVbpOxo/iYuPGU=;
        b=XbHKgChuzAZXL5/JwnPXFYash+/FCBmFsOciDFSG2RM1r6ibOTanxmn2JFBan9yx3F
         /4aKdhNUrmkE1bRVR8myr+uadH9bez8OHCthsu+FmlfLm/7ANJTLm4CHs6QPAatK2BM/
         H6M3funGEHDp3LCbHrJJsn0l48arOeyc4kEmxPbc0L10Ziishk5+benxX5cHZIJAD3SL
         vPkq7rt13ntPKUVx3xPir5wmxOy4+EMtF4B4sEiZkk62XtoOljpFwxkbAPMKJ+ApATdQ
         tKPxU/FQrLlKoseDsHDO9QbkZpLHSME+eaN36NK2c8EF79IEOe1nihtzq4lpBuNTEpVg
         INng==
X-Gm-Message-State: APjAAAVeaNoATrOXkfinfLPgt/wyzEhVa531Pm8ui3aZWsLCwZKJzNpt
        s2p8Qj+Z5e9okNQyM90VwZqkiaYO
X-Google-Smtp-Source: APXvYqyZv+69LhRIRnXv5yqnwbLPVmKpieJwXEkstB/8iw7yp/dMkS6I3Ezy5uhisKjzfYOGLsCMpQ==
X-Received: by 2002:a5d:5592:: with SMTP id i18mr17771232wrv.316.1569941863686;
        Tue, 01 Oct 2019 07:57:43 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm3220758wmj.17.2019.10.01.07.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 07:57:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] Reset CPU mask
Date:   Tue,  1 Oct 2019 17:57:38 +0300
Message-Id: <20191001145740.8866-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Reset CPU mask:
 - After setting it in trace-cmd record with option -M, to its previous
   value.
 - By the "trace-cmd reset" command, to its default value - all CPUs are
   enabled for tracing.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=204941

[
 v2 changes: 
  Addressed Steven Rostedt and Eugene Syromyatnikov <evgsyr@gmail.com>
 comments about the correct cpu mask in case we have more than 32 CPUs.
]

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Reset CPU mask after setting it in trace-cmd record with
    option -M
  trace-cmd: Reset CPU mask to its default value with "trace-cmd reset".

 tracecmd/trace-record.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

-- 
2.21.0

