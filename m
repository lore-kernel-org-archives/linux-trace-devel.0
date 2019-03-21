Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A639C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 19:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEEA9218FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 19:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfCUTYx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfCUTYx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 15:24:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F022175B;
        Thu, 21 Mar 2019 19:24:52 +0000 (UTC)
Date:   Thu, 21 Mar 2019 15:24:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Matt Helsley <mhelsley@vmware.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Message-ID: <20190321152450.7489e1d0@gandalf.local.home>
In-Reply-To: <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
        <20190319111924.17443-4-tstoyanov@vmware.com>
        <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 20 Mar 2019 16:32:25 +0000
Matt Helsley <mhelsley@vmware.com> wrote:

> > +/**
> > + * tep_check_flag - check the state of event parser flag
> > + * @tep: a handle to the tep_handle
> > + * @flag: flag, or combination of flags to be checked
> > + * can be any combination from enum tep_flag
> > + *
> > + * This checks the state of a flag or combination of flags from enum tep_flag
> > + */
> > +int tep_check_flag(struct tep_handle *tep, enum tep_flag flag)
> > +{
> > +	if (tep)
> > +		return (tep->flags & flag);
> > +	return 0;
> > +}  
> 
> This returns a subset of the flags directly — it doesn’t really check them -- that’s up to the caller.
> So  I’d say this is more of a “getter" than a “checker”.

If we want to be consistent with the kernel, the proper name is "test"

  tep_test_flag()


> 
> If returning a “boolean” is the true intent of the API then it should be:
> 
> return (tep->flags & flag) == flag;

Hmm, this has some side effects that would require documentation. It
makes it only return true if all flags are set, which is not what we
would want.

Since we are only dealing with one flag, (the parameter is an enum, so
multiple flags would not be correct), keeping the return value as is is
the proper approach.

But I'm fine with making the return value a bool and rename it to
"tep_test_flag()"

-- Steve


