Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2446C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 17:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiBVRjm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 12:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiBVRjl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 12:39:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB24166E12
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 09:39:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA89A612E1
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2D9C340E8;
        Tue, 22 Feb 2022 17:39:14 +0000 (UTC)
Date:   Tue, 22 Feb 2022 12:39:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs
 sources
Message-ID: <20220222123913.06415414@gandalf.local.home>
In-Reply-To: <20220222123143.6fbb81a6@gandalf.local.home>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220218225058.12701-2-beaub@linux.microsoft.com>
        <20220222123143.6fbb81a6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 12:31:43 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> static inline bool tracefs_user_event_test(struct tracefs_user_event *event)
> {
> 	return event && event->enable[0] != 0;
> }

I wonder if we need to add:

	return event && ((volatile char *)event->enable)[0] != 0;

to prevent the compiler from optimizing it.

-- Steve

