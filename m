Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058C8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Oct 2022 22:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJLW0o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJLW0o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 18:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C0BFFF8C;
        Wed, 12 Oct 2022 15:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF26A6162F;
        Wed, 12 Oct 2022 22:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26105C433B5;
        Wed, 12 Oct 2022 22:26:40 +0000 (UTC)
Date:   Wed, 12 Oct 2022 18:26:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Track event ref in tracefs enable/disable
Message-ID: <20221012182639.5a607add@rorschach.local.home>
In-Reply-To: <20221012215717.10492-1-beaub@linux.microsoft.com>
References: <20221012215717.10492-1-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 Oct 2022 14:57:17 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> When events are enabled via the "enable" file within tracefs there is no
> get or put ref. Add these to ensure modules and dynamic events do not
> unload while the event is enabled via tracefs.

Why is this an issue?

The events are only called from the module code, and when the module is
unloaded, they are no longer called. Why keep the module from unloading
when enabled?

-- Steve
