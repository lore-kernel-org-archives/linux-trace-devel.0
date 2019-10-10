Return-Path: <SRS0=o8EP=YD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD43C4360C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E609E206B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:24:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IcNBAl0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfJJVYy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:24:54 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45518 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJVYy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 17:24:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id q64so7662456ljb.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Oct 2019 14:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=An6rMMwi8Hrznzcf83b/KInrlJPowliouiPh1ymW2EY=;
        b=IcNBAl0xd8il97CdVxr6eozyYAo0LfzsIaeXAMPX5svWeJk8MYz72Q/TzrNMwfalMb
         EcSkWk4sUlWk9lheZbH+rYYvVkwSiIkBYaNYploY/K5yGByBeZx1IvJgwY15NoCHQhP9
         Y4NKbt325DR44QxHDtlXq6s81FNBsdJA8Rj9AMxlII7HHarwisLYC8AMQ0QeL69yk2+A
         g4FLbz6fPfpx/caICeAn9QF9gUOJWMDkTLxWDGmnjPFUaPjqZmSa3lTBOyuej+UxnKF5
         pYwj0IOJLLIfB1yc0vL4pZKhAkL6l7SfeEgUYD/mEnVPi+lR62tRj+v1Yb2LNT2hWH5g
         SSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=An6rMMwi8Hrznzcf83b/KInrlJPowliouiPh1ymW2EY=;
        b=opdzscKtyKHqUBRewfgDKaqYEGpL3NmVjWWhNlOFrrwLeORGOIXp95gbwcJbFAJTBJ
         JDdpQ4T1e+z5UipSe6sqKGK5ZlKEL1Mpf5knEJXUDFmp6f2IIgqEfSYh3eNGvD2KqRnf
         Qf11bC6kbW/UqhJJ+YkzI0y4SRCIkRisS7ecHNBGUSMtfHnlV5W50G9obAKnOErt//0O
         eVg5g8LFUfjH5fO/WEQFpBS0TZAS3ThdHwa9mkXS2qgk3y6UpfzZ+kM04ddVjSCGq3DK
         +EbH8bhWkRlxRDnQYsADazCBYCdYneu0H+raE+slGpImyQXva16bnjUxpCCvIY5t4o42
         DFuw==
X-Gm-Message-State: APjAAAVsDMSY0ytshv09AhBAw9WvReN+/UHTi8W9EygE6uLnux7qYrbz
        d0oChObBhFVzFpWCWIiFZLa1hzRheRc=
X-Google-Smtp-Source: APXvYqwNeG258rHbsNYNEUaTTI4Tb0jPLdYC6JzheyhnZe+/hYRq2V0BA+vRYzXmU2OrXtdj/Mq5Ww==
X-Received: by 2002:a2e:a0c9:: with SMTP id f9mr7574127ljm.77.1570742692473;
        Thu, 10 Oct 2019 14:24:52 -0700 (PDT)
Received: from localhost (128-72-185-159.broadband.corbina.ru. [128.72.185.159])
        by smtp.gmail.com with ESMTPSA id n2sm1497319ljj.30.2019.10.10.14.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 14:24:51 -0700 (PDT)
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <srostedt@redhat.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Mikhail Rudenko <mike.rudenko@gmail.com>
Subject: [PATCH 0/4] Fix KernelShark appearance on dark color schemes
Date:   Fri, 11 Oct 2019 00:24:25 +0300
Message-Id: <20191010212429.469155-1-mike.rudenko@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently a few widgets in Kernel Shark UI use custom stylesheets,
unconditionally setting their background or text color (but not both!)
to hard-coded values. This has a side effect of widget text being
poorly readable on some color schemes (e.g. Breeze Dark, and dark
schemes in general). This patch series tries to address this issue.

The first three patches are trivial: they ensure that whenever the
background color of a widget is set to white via stylesheet, its text
color is set to black.

The fourth one changes "inactive" marker selection button style to
system default, making it look clickable on all color schemes.

Mikhail Rudenko (4):
  kernel-shark: Set text color to black in KsDualMarker's QLabels
  kernel-shark: Set text color to black in pointer position QLabel
  kernel-shark: Set text color to black in KsTraceGraph's axes labels
  kernel-shark: Change KsDualMarker's inactive button style to default

 kernel-shark/src/KsDualMarker.cpp | 11 ++---------
 kernel-shark/src/KsTraceGraph.cpp |  6 ++++--
 2 files changed, 6 insertions(+), 11 deletions(-)

--
2.23.0
