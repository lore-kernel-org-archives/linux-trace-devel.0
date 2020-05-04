Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308ACC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 17:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E5E1206A4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 17:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGGs5Q7P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgEDRoB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 13:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgEDRoB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 13:44:01 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40C3C061A0E
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 May 2020 10:43:59 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u15so10599084ljd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 May 2020 10:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SXfjFDVPYEnPxpEecdsxLOeiQyRk7R7umFrKY0zDR+8=;
        b=OGGs5Q7PtdQD8IpGoMNEPxbSPu/yfH9DoFeP4lGaLG+rFQjozP5X8Ktw7mZGTSJS/f
         lmjMUy9DVPUakmLBnX4svCfoh2jiX7gXTtKqHvfhWOt2d8tdmhTEECxxODtMndjtQVIW
         Sp9m16PU8j09KoWI/EVFRwyAdMMOsJaZD3ANxmCLDC6NX7Rz32o+jug7QnCBJ1wQqEgj
         C+f8jQkn5lsHVr2KAmaTLpOIBO3YUb7WljWiHZfa6J+4S4+T0BaVl43Kc7c95C8qHkr2
         0nA4M6uzzmj9g+xIld41hn4HmGP8Z9AYT3lmuZV9rM8XyT7sf9DrH5kPjmpR94hJl+CU
         Dedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SXfjFDVPYEnPxpEecdsxLOeiQyRk7R7umFrKY0zDR+8=;
        b=VjHLh3Ey3y0y5K20CxrexaYbusY9FxbOWEUFyJ494bj772XkyYrXktCg47jj5xjYA6
         bK9s/BJvCASqkY4H0RhRuMcajPovgV3kr3r+IV17SKCotbwnBH9ivnrD5TbIIO7NLFA9
         cOjLHL2hyyyKjEfLge/UDsOM5dgzUpQ9mxbMcIvi92y4p4qnx7WVSLNznKDRAt4woC/u
         sYX2UQTVLTjIu69X+NQfSCLxLDoowcfmYg0o8V2pVRsT23tPM/ABpI76/adaPLDSvgur
         LhaOgiXTwHM5QfR72mQuFuPgAc/5Bmg99AHobM4SCYGxd+p5Mbq3SRr31RpOYm+SliF5
         rT8A==
X-Gm-Message-State: AGi0PubZV2gb5xDOkdOrEmLoTi4ku7AHnjC4xkFJlM4+0/hv+DBlcehq
        P7xssQgyE5W05biMfxi8VP2taC+IHrc=
X-Google-Smtp-Source: APiQypKGM1GSizNloEN7Nn1fUOGMawO7QkZu40JNrWw5C2w9rGEvhJpidd4lHH5+uwP+YIQi62WBNQ==
X-Received: by 2002:a2e:9012:: with SMTP id h18mr11061250ljg.28.1588614238348;
        Mon, 04 May 2020 10:43:58 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id g10sm10260845lfc.95.2020.05.04.10.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 10:43:57 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/3] kernel-shark: Have "stop" button for multi-threaded searches
Date:   Mon,  4 May 2020 20:43:39 +0300
Message-Id: <20200504174342.24615-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

So far "stop" button was available only during the single-threaded
searches. In order to make the multi-threaded searches stoppable
and restartable we are changing the searching mechanism making all
searching threads to progress in the data in parallel.

 Changes is v2:
 - Fix of the deadlock in the multi-threaded searche that occurs when
   the total number of entries is exactly multiple of the number of
   entries to be searched before updating the progress bar.

Yordan Karadzhov (VMware) (3):
  kernel-shark: Simplify the search methods in class KsTraceViewer
  kernel-shark: Change the mechanism of the multi-threaded search
  kernel-shark: Make the "stop search" button always visible

 kernel-shark/src/KsModels.cpp      |  89 ++++++++++++------
 kernel-shark/src/KsModels.hpp      |  16 ++--
 kernel-shark/src/KsSearchFSM.cpp   |  11 ++-
 kernel-shark/src/KsSearchFSM.hpp   |   5 +-
 kernel-shark/src/KsTraceViewer.cpp | 141 +++++++++++++++++++++++------
 kernel-shark/src/KsTraceViewer.hpp |   5 +-
 6 files changed, 195 insertions(+), 72 deletions(-)

-- 
2.20.1

