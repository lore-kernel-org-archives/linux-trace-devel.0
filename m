Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710076.outbound.protection.outlook.com ([40.107.71.76]:3041
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbeJJWuH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 18:50:07 -0400
Subject: Re: [PATCH 2/4] kernel-shark-qt: Add KernalShark Utils
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
 <20181008151629.13973-3-ykaradzhov@vmware.com>
 <20181009123419.22fe49f2@gandalf.local.home>
From: Yordan Karadzhov <ykaradzhov@vmware.com>
Message-ID: <ae5ae397-93b4-5f0e-f70a-e08a157f185d@vmware.com>
Date: Wed, 10 Oct 2018 18:27:11 +0300
MIME-Version: 1.0
In-Reply-To: <20181009123419.22fe49f2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  9.10.2018 19:34, Steven Rostedt wrote:
>> +
>> +/** @brief Unregister a Plugin.
>> + *<br> WARNING: Do not use this function to unregister User plugins.
> Hmm, do we need the <br> above? (if this is required by DocGen I find
> it rather ugly:-(  )

<br> means "break the line". Perhaps I can make it like this:


/** @brief Unregister a Plugin.
  *<br>
  * WARNING: Do not use this function to unregister User plugins.
  *
  * @param plugin: provide here the name of the plugin [...]
  *
  */

Thanks!
Yordan
