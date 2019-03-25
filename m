Return-Path: <SRS0=I4ei=R4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B20C10F03
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B9320811
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbfCYOuV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:50:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36699 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbfCYOuU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 10:50:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id y13so10533738wrd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Mar 2019 07:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RC6YkYMpWSKb9ALKUFnTSnBXIR+7VsWRj6RNCIVFHfM=;
        b=pvzxuGBSiKoha/cVkTj27ogJaEnNoTPlpT9rJxOxaSdH8gcwITALQn1vYgjibBMnn2
         upehG6Cz06TkUPUhrnqJkp/brrnP1VqE0TnP/Cw1LGvHnpc7pfm5nQu9TPWDo2Uff2Ou
         a308PuInVzcDFRgahb1ySU72fT+sxq76cEiIIB0JW3TAyvkDwwXGqe68hnMNKYCG5DAh
         R+J4dP+nTVNWazFXfXLv3gmOG97SPJ5rhrzsxNZXudDhDGbmqoPyjLL+JYNeB8ldYlOf
         +TpWYw4/CF1K8kSh4ageF/flXiLkE7fP6ZsCHnZvlhiJ1XqrLGltbmAtEsmF/pmN17GD
         BeDg==
X-Gm-Message-State: APjAAAWwItdd6lmDpERtoTTfaxWoMOVIfczTy9GPrZ9CFpG5lsCDURmM
        uzosqPQATwBPz60/JEtcqXHUB0g4
X-Google-Smtp-Source: APXvYqwtpN9TPbOAbV0eZSvsl4BJeM4gHlAh7aJ3nmjBx7ssAWgiOFm5VK5+oYD4mYWDPhWvicE9hw==
X-Received: by 2002:adf:f48f:: with SMTP id l15mr15654737wro.248.1553525419251;
        Mon, 25 Mar 2019 07:50:19 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 61sm24687595wre.50.2019.03.25.07.50.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:50:18 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/3] Few patches, related to libtracevent APIs
Date:   Mon, 25 Mar 2019 16:50:14 +0200
Message-Id: <20190325145017.30246-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset introduces new libtracevent APIs, which can be used for
accessing struct tep_handler fields. It also changes the description
of some APIs, to match more closely their logic.
There are also fixes to coding style problems, introduced by previous patches.

Tzvetomir Stoyanov (3):
  tools/lib/traceevent: Change description of few APIs
  tools/lib/traceevent: Coding style fixes
  tools/lib/traceevent: Implement new traceevent APIs for accessing
    struct tep_handler fields

 tools/lib/traceevent/event-parse-api.c | 156 ++++++++++++++++++++-----
 tools/lib/traceevent/event-parse.c     |   6 +-
 tools/lib/traceevent/event-parse.h     |   6 +
 3 files changed, 137 insertions(+), 31 deletions(-)

-- 
2.20.1

