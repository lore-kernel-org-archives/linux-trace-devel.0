Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4FDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 20:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiBUUj4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 15:39:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiBUUjz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 15:39:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2CD237DE
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 12:39:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9703AB81239
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 20:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD920C340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 20:39:28 +0000 (UTC)
Date:   Mon, 21 Feb 2022 15:39:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Account for events with newlines in print
 fmt
Message-ID: <20220221153927.139301d8@rorschach.local.home>
In-Reply-To: <20220221151828.2fd4d104@rorschach.local.home>
References: <20220221151828.2fd4d104@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 21 Feb 2022 15:18:28 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Subject: [PATCH] libtracefs: Account for events with newlines in print fmt

This was suppose to be libtraceevent not libtracefs.

Will resend :-p

-- Steve
