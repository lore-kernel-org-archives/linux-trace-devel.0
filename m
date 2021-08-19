Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03653C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF249610A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhHSTnX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:32944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235761AbhHSTnT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 15:43:19 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB61760FBF;
        Thu, 19 Aug 2021 19:42:40 +0000 (UTC)
Date:   Thu, 19 Aug 2021 15:42:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     victorcora98@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Add dependencies to BUILDING section in
 README
Message-ID: <20210819154233.3d4a75aa@oasis.local.home>
In-Reply-To: <20210813192516.24872-1-victorcora98@gmail.com>
References: <20210813192516.24872-1-victorcora98@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Aug 2021 16:25:16 -0300
victorcora98@gmail.com wrote:

> From: Victor Cora Colombo <victorcora98@gmail.com>

I finally got some time to look at this.

> 
> KernelShark has instructions in its README on how to get necessary
> dependencies to build it. trace-cmd could follow this example and
> also add more information on how to build it.
> 
> This patch adds instructions to README on how to get necessary libraries
> and dependencies to build trace-cmd.
> 
> Signed-off-by: Victor Cora Colombo <victorcora98@gmail.com>
> ---
>  README | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/README b/README
> index 1153152..094fce1 100644
> --- a/README
> +++ b/README
> @@ -24,6 +24,23 @@ Lesser General Public License 2.1 (See COPYING.LIB).
>  
>  BUILDING:
>  
> +In order to install build dependencies on Ubuntu do the following:
> +    sudo apt-get install build-essential git pkg-config -y
> +
> +In order to install build dependencies on Fedora, as root do the following:
> +    dnf install gcc make git pkg-config -y

I would actually add above libtracefs-devel and libtraceevent-devel for
fedora, and possibly libtracefs-dev and libtraceevent-dev for ubuntu /
debian. Oh, I would say that too, as I don't use Ubuntu thus, state "on
Debian / Ubuntu do the following".


> +
> +To install required dependencies:

Then you can say here.

In case the distribution does not have the required libtracefs and
libtraceevent libraries, install them manually:

Or something to that nature.

-- Steve


> +    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
> +    cd libtraceevent
> +    make
> +    sudo make install
> +
> +    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> +    cd libtracefs
> +    make
> +    sudo make install
> +
>  To make trace-cmd
>      make
>  

