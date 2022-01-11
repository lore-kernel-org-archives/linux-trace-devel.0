Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F9DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 00:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345851AbiAKARK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 19:17:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40424 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345622AbiAKARK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 19:17:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22EB1B81855
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 00:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBE4C36AED;
        Tue, 11 Jan 2022 00:17:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n74qY-002uDj-VK;
        Mon, 10 Jan 2022 19:17:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtraceevent: Allow %pIS to work with dynamic arrays
Date:   Mon, 10 Jan 2022 19:17:03 -0500
Message-Id: <20220111001705.692692-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Chuck Lever reported that adding the following:

#define field_sockaddr(field, len)  __dynamic_array(u8, field, len)
#define assign_sockaddr(dest, src, len)  memcpy(__get_dynamic_array(dest), src, len)
#define __get_sockaddr(field)  ((struct sockaddr *)__get_dynamic_array(field))

TRACE_EVENT(sockaddr_example,
        TP_PROTO(
                const struct sockaddr *sap,
                size_t salen
        ),  
        TP_ARGS(sap, salen),
        TP_STRUCT__entry(
                __field_sockaddr(addr, salen)
        ),  
        TP_fast_assign(
                __assign_sockaddr(addr, sap, salen);
        ),  
        TP_printk("addr=%pIS", __get_sockaddr(addr))
);

Causes trace-cmd to report:

  "addr=ARG TYPE NOT FIELD BUT 7"

Which is not only unwanted, but rather unhelpful.

Fix it to allow %pIS to work with dynamic arrays, and also allow all fields to
still work if they are typecasted.

Link: https://lore.kernel.org/all/164182978641.8391.8277203495236105391.stgit@bazille.1015granger.net/

Steven Rostedt (2):
  libtraceevent: Do not fail field parsing if field has typecast
  libtraceevent: Allow ipsa arg to use dynamic arrays

 src/event-parse.c | 70 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 16 deletions(-)

-- 
2.33.0

