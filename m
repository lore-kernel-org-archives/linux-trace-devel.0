Return-Path: <SRS0=k4No=JM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbeFZPS2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jun 2018 11:18:28 -0400
Date: Tue, 26 Jun 2018 11:18:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 5/7] kernel-shark-qt: Add a README file to
 trace-cmd/kernel-shark-qt
Message-ID: <20180626111826.0a19b441@gandalf.local.home>
In-Reply-To: <d336e69a-0e95-4cba-d8a5-0756a150b2c2@gmail.com>
References: <20180625150121.14291-1-y.karadz@gmail.com>
        <20180625150121.14291-6-y.karadz@gmail.com>
        <20180625143810.6c1c5189@gandalf.local.home>
        <d336e69a-0e95-4cba-d8a5-0756a150b2c2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 26 Jun 2018 17:51:07 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> > I'm not so sure how useful this "third party software" section is. I
> > think it's pretty obvious that gcc, c++ and cmake will be needed.
> >   
> 
> I would like to have here instructions how to build the code on a 
> default out-of-the-box installation of Ubuntu or Fedora. I agree that it 
> doesn't make sense as it is right now, but it will start making sense 
> when we start adding more and more dependencies.

OK, I'm just worried about maintaining it.

> > Note, after all the code is in the repo, I expect to have the top level
> > Makefile, do all the cmake work for the user.
> >   
> 
> Do you mean, you want to completely remove this README file?
> 

We may not need to, if it can still be built separately. But ideally, I
want people to simply type "make gui" at the top level and it does
everything (cmake and all). I don't think that will be to difficult to
implement. I was actually planning on doing the implementation myself.

-- Steve
