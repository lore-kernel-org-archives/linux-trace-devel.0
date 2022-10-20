Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C7AC43217
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Oct 2022 20:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJTUzZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Oct 2022 16:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJTUzZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Oct 2022 16:55:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E68E09A0;
        Thu, 20 Oct 2022 13:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6007D61D12;
        Thu, 20 Oct 2022 20:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293B6C433C1;
        Thu, 20 Oct 2022 20:55:22 +0000 (UTC)
Date:   Thu, 20 Oct 2022 16:55:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 1/2] rv/dot2c: Make automaton definition static
Message-ID: <20221020165526.18dcaa02@gandalf.local.home>
In-Reply-To: <73cbfbaf-9397-00ab-4844-e5dd96958912@kernel.org>
References: <ffbb92010f643307766c9307fd42f416e5b85fa0.1661266564.git.bristot@kernel.org>
        <20221018182553.06f13a50@gandalf.local.home>
        <73cbfbaf-9397-00ab-4844-e5dd96958912@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 19 Oct 2022 15:15:54 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> On 10/19/22 00:25, Steven Rostedt wrote:
> > On Tue, 23 Aug 2022 17:20:28 +0200
> > Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> >   
> >> Monitor's automata definition is only used locally, so make dot2c generate
> >> a static definition.
> >>
> >> Link: https://lore.kernel.org/all/202208210332.gtHXje45-lkp@intel.com
> >> Link: https://lore.kernel.org/all/202208210358.6HH3OrVs-lkp@intel.com
> >>  
> > Somehow this fell through the cracks.
> > 
> > Daniel, is there any reason I shouldn't pull this in now?  
> 
> Oops... yes, it can be pulled.
> 

OK, I'm going to push this up as tools/urgent and send a pull request to
Linus.

-- Steve
