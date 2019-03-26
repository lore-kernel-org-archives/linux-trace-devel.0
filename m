Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A839DC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 19:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84F4E2084B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 19:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731690AbfCZTsu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbfCZTsu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 15:48:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45C3620823;
        Tue, 26 Mar 2019 19:48:49 +0000 (UTC)
Date:   Tue, 26 Mar 2019 15:48:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] tools/lib/traceevent: Add counter to track parsing
 failures
Message-ID: <20190326154847.4c1062b9@gandalf.local.home>
In-Reply-To: <20190326154328.28718-3-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
        <20190326154328.28718-3-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Mar 2019 17:43:22 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch adds a parsing failures counter to struct tep_handle. The counter can
> be used to track failures on parsing event format files. It is updated
> automatically by tep_parse_event(), when failure is detected. The patch also
> adds two new APIs for accessing the counter:
>  tep_get_parsing_failures() - returns the current value of the counter.
>  tep_clear_parsing_failures() - clears the counter.
> 

I think we can do the same thing here as we did test_filters.

I don't think we really need to put this into the tep interface. Let's
see if we can move this into trace-cmd itself and have it just keep
track of when parsing failed.

I mean, trace-cmd is just using the tep structure as place to store
this variable.

-- Steve
