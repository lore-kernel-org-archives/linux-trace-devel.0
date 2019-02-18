Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2059C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 17:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA9C4217F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 17:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388101AbfBRRok (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387866AbfBRRok (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 12:44:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57D4D2146F;
        Mon, 18 Feb 2019 17:44:39 +0000 (UTC)
Date:   Mon, 18 Feb 2019 12:44:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 07/11] trace-cmd: Add `trace-cmd setup-guest`
 command
Message-ID: <20190218124437.0761e27b@gandalf.local.home>
In-Reply-To: <20190218143746.GD11734@box>
References: <20190214141335.28144-1-kaslevs@vmware.com>
        <20190214141335.28144-8-kaslevs@vmware.com>
        <20190214154132.43082ece@gandalf.local.home>
        <20190218143746.GD11734@box>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 18 Feb 2019 16:37:47 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> This won't work as proposed: `p` will be NULL on the last iteration but will
> still get incremented from the outer for-loop and the check (p && *p) won't get
> triggered (p == 0x01 in this case).

I still don't like the "end", it just looks awkward.

> 
> A fixed version might look like this:
> 
> static int make_dir(const char *path, mode_t mode)
> {
> 	char buf[PATH_MAX+1], *p;
> 	int ret = 0;
> 
> 	strncpy(buf, path, sizeof(buf));
> 	for (p = buf; *p; p++) {
> 		for (; *p == '/'; p++);
> 		p = strchr(p, '/');
> 
> 		if (p)
> 			*p = '\0';
> 		ret = mkdir(buf, mode);
> 		if (ret < 0) {
> 			if (errno != EEXIST) {
> 				ret = -errno;
> 				break;
> 			}
> 			ret = 0;
> 		}
> 		if (!p)
> 			break;
> 		*p = '/';
> 	}
> 
> 	return ret;
> }
> 
> OTOH I find the original version much more readable:
> 
> static int make_dir(const char *path, mode_t mode)
> {
> 	char buf[PATH_MAX+1], *end, *p;
> 	int ret = 0;
> 
> 	end = stpncpy(buf, path, sizeof(buf));
> 	for (p = buf; p < end; p++) {
> 		for (; p < end && *p == '/'; p++);
> 		for (; p < end && *p != '/'; p++);
> 
> 		*p = '\0';
> 		ret = mkdir(buf, mode);
> 		if (ret < 0) {
> 			if (errno != EEXIST) {
> 				ret = -errno;
> 				break;
> 			}
> 			ret = 0;
> 		}
> 		*p = '/';
> 	}
> 
> 	return ret;
> }
> 
> The intent behind `*p = '\0'; ... *p = '/';` is more clearly expressed in this
> version without getting bogged down by strchr() edge case handling.
> 
> Since this is not on a performance critical path how about sticking to the more
> readable of the two?
> 

I'd still like to use '*p' as that's very common.

Also break up the other for loops into a while loops.

	for (p = buf; *p; p++) {

		while (*p == '/')
			p++;
		while (*p && *p != '/')
			p++;

		if (*p)
			*p = '\0';
		else
			p--; /* for the for loop */

		[...]


This would work, and I think is still readable. It matches more the
standard way of the Linux kernel as well.

-- Steve
