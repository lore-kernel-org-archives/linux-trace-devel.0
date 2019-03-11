Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D411C4360F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 18:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 108E2206BA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 18:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfCKSXe convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 14:23:34 -0400
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:35423 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726864AbfCKSXe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 14:23:34 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2019 14:23:33 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id A83631803323C
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 18:16:15 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id D383C8368EE8;
        Mon, 11 Mar 2019 18:16:14 +0000 (UTC)
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-HE-Tag: rice75_1952e87692707
X-Filterd-Recvd-Size: 4935
Received: from [IPv6:2607:fb90:4a4:c73b:8c47:db71:528:ea44] (unknown [172.56.38.70])
        (Authenticated sender: rostedt@goodmis.org)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Mon, 11 Mar 2019 18:16:13 +0000 (UTC)
Date:   Mon, 11 Mar 2019 11:15:40 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <f4a51b16-446a-a426-a8b4-71365b8829c4@gmail.com>
References: <20190307154316.19194-1-ykaradzhov@vmware.com> <20190307154316.19194-5-ykaradzhov@vmware.com> <CAE0o1NsXJCV65iRzCMTs_-R8H2ET1TiN4aY20EU5hvkTHOju5Q@mail.gmail.com> <351105f9-557d-5a2d-99f1-0f93db2848be@gmail.com> <CAE0o1Nv5g6wujxY8ey2mQ72kk977s7tCWq9Hcab1zfNU3rNOVg@mail.gmail.com> <f4a51b16-446a-a426-a8b4-71365b8829c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v2 4/4] kernel-shark: Fix a bug in KsPluginManager
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <slavomir.kaslev@gmail.com>
CC:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
From:   Steven Rostedt <rostedt@goodmis.org>
Message-ID: <55A448CA-1F0F-4396-89D0-22515B630A28@goodmis.org>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On March 11, 2019 10:55:57 AM PDT, "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>
>
>On 11.03.19 г. 15:44 ч., Slavomir Kaslev wrote:
>> On Mon, Mar 11, 2019 at 3:20 PM Yordan Karadzhov (VMware)
>> <y.karadz@gmail.com> wrote:
>>>
>>>
>>>
>>> On 11.03.19 г. 14:09 ч., Slavomir Kaslev wrote:
>>>> On Thu, Mar 7, 2019 at 5:44 PM Yordan Karadzhov
><ykaradzhov@vmware.com> wrote:
>>>>>
>>>>> const char *lib = plugin.toStdString().c_str();
>>>>>
>>>>> This line is a bad idea because the returned array may (will) be
>>>>> invalidated when the destructor of std::string is called.
>>>>>
>>>>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>>>>> ---
>>>>>    kernel-shark/src/KsUtils.cpp | 4 ++--
>>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/kernel-shark/src/KsUtils.cpp
>b/kernel-shark/src/KsUtils.cpp
>>>>> index 34b2e2d..d7b1753 100644
>>>>> --- a/kernel-shark/src/KsUtils.cpp
>>>>> +++ b/kernel-shark/src/KsUtils.cpp
>>>>> @@ -439,7 +439,7 @@ void
>KsPluginManager::registerFromList(kshark_context *kshark_ctx)
>>>>>
>>>>>           auto lamRegUser = [&kshark_ctx](const QString &plugin)
>>>>>           {
>>>>> -               const char *lib = plugin.toStdString().c_str();
>>>>> +               const char *lib = plugin.toLocal8Bit().data();
>>>>>                   kshark_register_plugin(kshark_ctx, lib);
>>>>>           };
>>>>>
>>>>> @@ -474,7 +474,7 @@ void
>KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
>>>>>
>>>>>           auto lamUregUser = [&kshark_ctx](const QString &plugin)
>>>>>           {
>>>>> -               const char *lib = plugin.toStdString().c_str();
>>>>> +               const char *lib = plugin.toLocal8Bit().data();
>>>>>                   kshark_unregister_plugin(kshark_ctx, lib);
>>>>>           };
>>>>
>>>> Doesn't the new version have the same problem with the temporary
>QByteArray?
>>>>
>>>> How about saving the data in a local std::string/QByteArray
>variable?
>>>>
>>>>                  std::string lib = plugin.toStdString();
>>>>                  kshark_register_plugin(kshark_ctx, lib.c_str());
>>>>
>>>
>>> Hi Slavi,
>>>
>>> As far I can understand toStdString() will create a fresh
>std::string
>>> and this string will has its own copy of the characters. However,
>this
>>> copy gets out-of-scope as soon as we hit the semicolon of the line.
>>>
>>> My understanding was that toLocal8Bit().data() makes no copy so the
>>> array will go out-of-scope only when the QString is destroyed.
>> 
>> I did some digging into QString's implementation. From my reading of
>> the code, toLocal8Bit() calls into qt_convert_to_latin1()[1] which
>> does allocation, copying/transform-to-latin1 and returns the
>> QByteArray. So it seems that toLocal8Bit() is still making a copy.
>> 
>> [1]
>https://github.com/qt/qtbase/blob/5.12/src/corelib/tools/qstring.cpp#L5275
>> 
>> Cheers,
>> 
>
>Thanks a lot for investigating this!
>I think in this case it will be more appropriate if you sign the patch.
>cheers,
>Y.
>
>> -- Slavi
>> 
>>>
>>> But anyway, your solution looks cleaner and safer.
>>> I will send another version of the patch.
>>> Thanks a lot!


Signing the patch means that the person either wrote the patch or handled it to be committed.

I think you want Suggested-by:

-- Steve

>>> Y.
>>>
>>>
>>>> Thanks!
>>>>
>>>>
>>>> --
>>>> Slavomir Kaslev
>>>>
>> 
>> 
>> 

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity and top posting.
