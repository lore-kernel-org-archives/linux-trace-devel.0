Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88F2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Oct 2022 19:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJTTPO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Oct 2022 15:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJTTPN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Oct 2022 15:15:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E597B599
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Oct 2022 12:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A0A6B828E6
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Oct 2022 19:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E47EC433D6;
        Thu, 20 Oct 2022 19:15:08 +0000 (UTC)
Date:   Thu, 20 Oct 2022 15:15:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michael Petlan <mpetlan@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix several Coverity andf Clang warnings in
 libtraceevent
Message-ID: <20221020151512.3bdc783b@gandalf.local.home>
In-Reply-To: <20220930111002.6107-1-mpetlan@redhat.com>
References: <20220930111002.6107-1-mpetlan@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 30 Sep 2022 13:09:59 +0200
Michael Petlan <mpetlan@redhat.com> wrote:

> Hello.
> 
> When rebasing to libtraceevent-1.5.3 in RHEL, Coverity has found some
> issues. I have tried to fix them. Could you please have a look at the
> patches attached?
> 
> Thank you.

Applied. Thanks Michael!

-- Steve
