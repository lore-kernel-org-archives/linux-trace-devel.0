Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED971C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD22A2133D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551367839;
	bh=FoUF+5g/73J8ystPvFXKVhNp8xUEcXy9gjnsYmtdFnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zWcz17CVw/gWlbwLORpZvImn/rT9U+qs9gi2pPwv0p+J+Kf/oHNeJyiK0CgM8K2EK
	 Cf/LBFtrgxg7bbMBCADLjImZsWgGW1h9r1YlVTA9eIbFWL1KijZz4DLv20XP5gDz6u
	 CecNw9HI+l1BFD6hq1zPQ+Zxdpg3ygywDTwRZUuc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389083AbfB1Pab (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:30:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388199AbfB1Paa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 10:30:30 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A3F220C01;
        Thu, 28 Feb 2019 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551367829;
        bh=FoUF+5g/73J8ystPvFXKVhNp8xUEcXy9gjnsYmtdFnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXg2BEu9uvyIrGnYY1H2xHSvsBTTC0Bw2O8Xe15B3vtX7uBbYluhjIzV+DkQImNCu
         l9OShgE8+8QX+elbMFm41ogZTWoWHX0vGLLKtdrulSeAStcD4Y/ZR38/7aVZeTlz8L
         qYGIFiNscATLsVwmRCma1qDbJCkNoRN02xMalsBo=
Date:   Thu, 28 Feb 2019 16:30:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        qais.yousef@arm.com, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190228153026.GG8481@kroah.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228173444.54403795211d80ba540b61cb@kernel.org>
 <20190228150054.GB156098@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228150054.GB156098@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 10:00:54AM -0500, Joel Fernandes wrote:
> > Hmm, isn't it easier to add kernel-headers package on Android?
> 
> I have already been down that road. In the Android ecosystem, the Android
> teams only provide a "userspace system image" which goes on the system
> partition of the flash (and a couple other images are also provided but
> system is the main one). The system image cannot contain GPL source code.

Note, that last sentance is not true, it can contain whatever license
code it wants to, as long as the group doing the distribution abides by
the license of the code contained in it.

The split of system and other images has nothing to do with license
issues, but rather functional requirements.  There _might_ be GPL
licensed code in the image if it meets a requirement for the proper
functionality of the system, you never know :)

thanks,

greg "not a lawyer but I work with a lot of them all the time" k-h
