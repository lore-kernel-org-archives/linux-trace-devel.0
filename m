Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700089.outbound.protection.outlook.com ([40.107.70.89]:28064
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726525AbeJJWus (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 18:50:48 -0400
Subject: Re: [PATCH 2/4] kernel-shark-qt: Add KernalShark Utils
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
 <20181008151629.13973-3-ykaradzhov@vmware.com>
 <20181009123419.22fe49f2@gandalf.local.home>
From: Yordan Karadzhov <ykaradzhov@vmware.com>
Message-ID: <008c5da4-1566-b588-180c-afa31b352eb2@vmware.com>
Date: Wed, 10 Oct 2018 18:27:53 +0300
MIME-Version: 1.0
In-Reply-To: <20181009123419.22fe49f2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


On  9.10.2018 19:34, Steven Rostedt wrote:
> Is this private to libkshark and not going to be exported?
> 
> In other words, do we need to worry about namespace?

The namespace here is used mostly for making the code easy to read.
C++ people do this because it makes the code look more OO-ish.

Note that

namespace Foo
{
	bool bar1(int x);

	void bar2();
};

is equivalent to

class Foo {
	static bool bar1(int x);

	static void bar2();
};

Thanks!
Yordan
