Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5160C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 938C2218B0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551368721;
	bh=Ydlgv1/bff/mSevUXLvGNXBcCLd3Pdau1gdmz5r23FM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=S1qHBNvz78f6rSJEhM7I8MBpULAyt8gX0B1z7mCC41zW1CdWMdcaoMFMVWjOWTRU+
	 gi3lgrWYZyGMfHdG0V3sxbC120FaE9R9iEiBNo0Of4KQKv2sSDEjc27HnMFBZY7UFX
	 EJ9datJziIDjf1y7LSPzFGTVqgU6PA1KebxL1lsY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfB1PpQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfB1PpQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 10:45:16 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A43C218AE;
        Thu, 28 Feb 2019 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551368715;
        bh=Ydlgv1/bff/mSevUXLvGNXBcCLd3Pdau1gdmz5r23FM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cWAoikD7kg5yMucDCVwxzJBeOoHS9h/sXmVFivUTpJVwFv6lcCsNkJqIDj/LWKl8L
         erMNTmz2y3HRmsPqHWPXc8G1lrxDe0hCEGhErpnqWDzr3jxhokXWiuegE6NfImPGji
         zyM8cQQqqK2wxxKYjjqfBkdhhuJoKUVoucEXoRc0=
Date:   Thu, 28 Feb 2019 16:45:13 +0100
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
Message-ID: <20190228154513.GA12050@kroah.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228173444.54403795211d80ba540b61cb@kernel.org>
 <20190228150054.GB156098@google.com>
 <20190228153026.GG8481@kroah.com>
 <20190228153741.GA168373@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228153741.GA168373@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 10:37:41AM -0500, Joel Fernandes wrote:
> In any case, it is not practical to provide headers for every kernel version on
> the system image and maintain them, it will take up too much space and has to
> be periodically packaged. Not to mention that there will be kernel versions
> that are booting Android that simply don't have anyone maintaining headers
> for. So the proposed solution is an easier path.

I totally agree with this, and with your proposed patches, just wanting
to clear up some potential anti-GPL-FUD before it got spread any further :)

thanks,

greg k-h
