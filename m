Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63842C76196
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 14:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbjC1OpU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 10:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbjC1OpR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 10:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39165BBA3
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 07:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3FF7B81D67
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 14:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B3CC433A1;
        Tue, 28 Mar 2023 14:44:52 +0000 (UTC)
Date:   Tue, 28 Mar 2023 10:44:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH trace-cmd] trace-cmd report: Ensure filter is applied to
 single input file
Message-ID: <20230328104450.3b6984e8@gandalf.local.home>
In-Reply-To: <87h6u5x82c.fsf@suse.de>
References: <20230317212430.12675-1-krisman@suse.de>
        <20230327181103.3da07fa2@gandalf.local.home>
        <87h6u5x82c.fsf@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 28 Mar 2023 11:30:03 -0300
Gabriel Krisman Bertazi <krisman@suse.de> wrote:

> > I actually wanted this just a few minutes ago ;-)
> >
> > Can you do this, or would you want me to?  
> 
> sure, i can do that.
> 
> Unless you are in a hurry, let me take a look later this week.

No hurry. Thanks.

-- Steve
