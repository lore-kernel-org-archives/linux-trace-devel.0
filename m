Return-Path: <SRS0=sU+T=WE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4ADC433FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 11:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09952216C8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 11:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBf6amz1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfHHLgl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 07:36:41 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:39616 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728542AbfHHLgl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 07:36:41 -0400
Received: by mail-wr1-f44.google.com with SMTP id t16so4454585wra.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Aug 2019 04:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jk2tph/95/0GT401/deJM0pJCwEgo6ETkcKcDTe+C90=;
        b=RBf6amz1V3FAXdP8pC20KkWkikrDKup+p++0fxkA4NRrd/tBVnqC5gQ5wcLRg1OsEh
         8aoswziHy34s3LrZFWr/5o9ATN7WqBrMv8HVplkU55HNV+aUbz1ZSDB4FW6qqmS06O7O
         Xouv8yYAXxp7H6hDrT6NjVHOPb7Nu+tu2okAlSRG8YwnwuCjbImeX3IRMtWzq8VixTSI
         QkfMhWwGbhRE/bwTiFnpTUvJ+mt4kVvbIcl/hgBWbUqPiV7WCrhRU9UtZ17gZr/WeTDb
         VMD8h06wP5SS+w1Yw95KCgKkB6jGbxqkbXPrjACOhHPkDvnrEZTV2shsggSTpMi8oiCE
         c6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jk2tph/95/0GT401/deJM0pJCwEgo6ETkcKcDTe+C90=;
        b=QkmFEpUwPfbqpi4lJcG8JwGWjocRMU4hsRDqDuPKgA0/ixbpihTZqqL7OW0NkpndT6
         cN+5X9I0eSB4hANvu0kSn9hwwvK7Z3aWzKc15aMdlGj9dlQo+pVlE4SvPldDl674XUzc
         E0RIkIEgquW7ifMS9vkkps7PLVJV2TgdfSM9A43WHKX0r23DYvSawnZ7SyznjHuskWUb
         kby9CWo5aYQVld/U8vqLUrgpcgssS8UW5FlIkeM0f64kVq6rQTv03Y+bT9ocQwohqqrT
         Twq/vdxomqb5RJf+TPDMztzIDp3GW4B3WqCSUwOuYSz7F2VWank2DEyqCbt+rzVdQhT9
         Ilrw==
X-Gm-Message-State: APjAAAVu4SOjos9j9JuN6HebhX8BYf6HrBTI1uMaGFT4cA58r3FPNRsh
        vMAbyKYP9EwrsSa1rFZOBKWepHi9jXU=
X-Google-Smtp-Source: APXvYqxtC+EMcIPiDbelHprxyLPDIznnJEg7yf/Nm1hHaZ5M4VDk1/KVFQRMF2leyVasVisAVHENLQ==
X-Received: by 2002:adf:a54d:: with SMTP id j13mr144760wrb.261.1565264198898;
        Thu, 08 Aug 2019 04:36:38 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l16sm5127992wrt.31.2019.08.08.04.36.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 04:36:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Fixed outdated libtraceevent man pages.
Date:   Thu,  8 Aug 2019 14:36:34 +0300
Message-Id: <20190808113636.13299-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The main libtraceevent man page is not up to date with the latest
changes in the library APIs.

Tzvetomir Stoyanov (VMware) (2):
  tools/lib/traceevent: Man pages fix, rename tep_ref_get() to
    tep_get_ref()
  tools/lib/traceevent: Man pages fix, changes in event printing APIs

 .../Documentation/libtraceevent-handle.txt    |   8 +-
 .../libtraceevent-latency_format.txt          | 154 ------------------
 .../Documentation/libtraceevent.txt           |  15 +-
 3 files changed, 6 insertions(+), 171 deletions(-)
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt

-- 
2.21.0

