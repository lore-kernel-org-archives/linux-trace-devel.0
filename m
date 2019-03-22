Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B57C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 12:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31A8A2083D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 12:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbfCVMQr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390269AbfCVMQq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 08:16:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A4D821900;
        Fri, 22 Mar 2019 12:16:45 +0000 (UTC)
Date:   Fri, 22 Mar 2019 08:16:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Matt Helsley <mhelsley@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Message-ID: <20190322081644.7762c325@gandalf.local.home>
In-Reply-To: <CACqStof40CSX=rh3B53qAH+kPy6HvePu1Mw9LY1KNzgp93Sd8A@mail.gmail.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
        <20190319111924.17443-4-tstoyanov@vmware.com>
        <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
        <20190321154602.5c49bd38@gandalf.local.home>
        <CACqStof40CSX=rh3B53qAH+kPy6HvePu1Mw9LY1KNzgp93Sd8A@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Mar 2019 11:33:47 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:


> > >
> > > int tep_host_bigendian(void);  
> >
> > Rename to: bool tep_is_bigendian()  
> 
> Steven, int tep_host_bigendian(void) actually checks the endianness of
> the host -
> I think it makes sens "host" to be part of API's name. The other one:
> int tep_is_host_bigendian(struct tep_handle *pevent) checks the
> endianness stored
> in the tep_handle, I think we should remove "host" from its name.
> 

I hate the word "host" here. Because what would you get if you run this
on a guest? You get the "guest" endianess (which may possibly be not
the same as the host (if emulated)).


I want to keep this as "tep_is_bigendian()" as it doesn't take a
parameter, and is obvious to what it is returning.

> > > int tep_file_bigendian(struct tep_handle *pevent);  
> >
> > Rename to: bool tep_is_file_bigendian()
> >  
> > > void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian);
> > > int tep_is_host_bigendian(struct tep_handle *pevent);  
> >
> > Rename to: bool tep_is_host_bigendian()
> >  

Let's rename this to:

void tep_set_local_bigendian()
bool tep_is_local_bigendian()

It can be argued that this could be for the above (test this machine),
but since the "test this machine" doesn't take a parameter, but "test
the pevent bigendian" does, I want it to be consistent with
tep_is_file_bigendian(), which also takes a parameter.

   bool tep_is_bigendian(void);
   bool tep_is_file_bigendian(struct tep_handle *tep);
   bool tep_is_local_bigendian(struct tep_handle *tep);

seems more consistent than:

   bool tep_is_local_bigendian(void);
   bool tep_is_file_bigendian(struct tep_handle *tep);
   bool tep_is_bigendian(struct tep_handle *tep);

So lets go with the first one.

Make sense?

-- Steve
