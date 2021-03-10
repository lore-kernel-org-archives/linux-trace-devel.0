Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84790C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 15:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E73264F77
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 15:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhCJP1v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 10:27:51 -0500
Received: from foss.arm.com ([217.140.110.172]:48254 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231244AbhCJP1m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 10:27:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D4F531B;
        Wed, 10 Mar 2021 07:27:41 -0800 (PST)
Received: from localhost.localdomain (unknown [10.57.54.30])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3CFA03F793;
        Wed, 10 Mar 2021 07:27:41 -0800 (PST)
From:   Vincent Donnefort <vincent.donnefort@arm.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH] trace-cmd: Fix mmap error path in allocate_page_map()
Date:   Wed, 10 Mar 2021 15:27:30 +0000
Message-Id: <20210310152730.3661-1-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A typo in allocate_page_map() led to not testing mmap failure and using
the defunct pointer as a valid one.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f9d09d2..2093a3d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1004,7 +1004,7 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	page_map->map = mmap(NULL, map_size, PROT_READ, MAP_PRIVATE,
 			 handle->fd, map_offset);
 
-	if (page->map == MAP_FAILED) {
+	if (page_map->map == MAP_FAILED) {
 		/* Try a smaller map */
 		map_size >>= 1;
 		if (map_size < handle->page_size) {
-- 
2.27.0

