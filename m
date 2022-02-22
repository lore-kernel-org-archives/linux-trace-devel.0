Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB15C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 18:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiBVTAQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 14:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiBVTAQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 14:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438CA151349
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 10:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7B07B81C5C
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 18:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4985EC340E8;
        Tue, 22 Feb 2022 18:59:47 +0000 (UTC)
Date:   Tue, 22 Feb 2022 13:59:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs
 sources
Message-ID: <20220222135945.3fa36368@gandalf.local.home>
In-Reply-To: <20220222174634.GB1709@kbox>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220218225058.12701-2-beaub@linux.microsoft.com>
        <20220222123143.6fbb81a6@gandalf.local.home>
        <20220222174634.GB1709@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 09:46:34 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Yes, I was thinking along the same lines. I saw how things were split
> between private / public in the headers and wasn't sure how to
> accomplish this.
> 
> What you have above seems like a great way to accomplish this without exposing
> too much out.

Just in case we ever want to extend the user view, I wonder if we should
also expose the size as the next argument (or the first).

struct tracefs_user_event {
	unsigned int		size;
	char			*enable;
};

and set size to sizeof(struct tracefs_user_event).

Then if we add another field, we can differentiate it from new additions,
without breaking forward or backward API.

-- Steve
