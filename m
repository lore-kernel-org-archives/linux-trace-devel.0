Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A119C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 17:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiBVRLZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 12:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiBVRLY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 12:11:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF44D1082
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 09:10:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 579B0CE13B3
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFE8C340E8;
        Tue, 22 Feb 2022 17:10:55 +0000 (UTC)
Date:   Tue, 22 Feb 2022 12:10:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs
 sources
Message-ID: <20220222121054.2649b09e@gandalf.local.home>
In-Reply-To: <20220222165946.GA1709@kbox>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220218225058.12701-2-beaub@linux.microsoft.com>
        <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com>
        <20220221175720.GA1738@kbox>
        <20220221141625.60a7db50@rorschach.local.home>
        <c2b27dce-96fb-176e-51b9-df6f1ce760fa@gmail.com>
        <20220222090021.3f2ba377@rorschach.local.home>
        <20220222165946.GA1709@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 08:59:46 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> > Thoughts?  
> 
> Many times we have found that we have to do work that should only be
> performed if the event is enabled. As long as there is a still clear
> ways to check without the macro, this would be fine with me.
> 
> IE: strlen(message)
> 
> We should not walk strings unless the event is enabled.

Right. The macro would only be a helper macro. I would even add it as a
separate patch at the end and not part of the main patch.

-- Steve
