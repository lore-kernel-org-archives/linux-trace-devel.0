Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbeJKC2E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 22:28:04 -0400
Date: Wed, 10 Oct 2018 15:04:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] kernel-shark-qt: Add KernalShark Utils
Message-ID: <20181010150433.70f38e55@gandalf.local.home>
In-Reply-To: <008c5da4-1566-b588-180c-afa31b352eb2@vmware.com>
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
        <20181008151629.13973-3-ykaradzhov@vmware.com>
        <20181009123419.22fe49f2@gandalf.local.home>
        <008c5da4-1566-b588-180c-afa31b352eb2@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 10 Oct 2018 18:27:53 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> On  9.10.2018 19:34, Steven Rostedt wrote:
> > Is this private to libkshark and not going to be exported?
> > 
> > In other words, do we need to worry about namespace?  
> 
> The namespace here is used mostly for making the code easy to read.
> C++ people do this because it makes the code look more OO-ish.
> 
> Note that

Never mind. My question was because I *missed* seeing:

 +namespace KsUtils {

And was asking if we want to have a namespace.

-- Steve

> 
> namespace Foo
> {
> 	bool bar1(int x);
> 
> 	void bar2();
> };
> 
> is equivalent to
> 
> class Foo {
> 	static bool bar1(int x);
> 
> 	static void bar2();
> };
> 
> Thanks!
> Yordan
