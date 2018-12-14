Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35799 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730128AbeLNMCp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 07:02:45 -0500
Received: by mail-wm1-f65.google.com with SMTP id c126so5551961wmh.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Dec 2018 04:02:44 -0800 (PST)
Subject: Re: [PATCH 1/5] kernel-shark-qt: Avoid spurious searches
To: Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
References: <20181212165826.8218-1-ykaradzhov@vmware.com>
 <20181212165826.8218-2-ykaradzhov@vmware.com>
 <20181213224739.0510e951@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <2b57d6cf-fd9c-821f-26eb-caf7c6256870@gmail.com>
Date: Fri, 14 Dec 2018 14:02:40 +0200
MIME-Version: 1.0
In-Reply-To: <20181213224739.0510e951@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 14.12.18 г. 5:47 ч., Steven Rostedt wrote:
> On Wed, 12 Dec 2018 16:58:44 +0000
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> Do not search if the text field of search panel is empty.
>> Most probably this is an accidental key press or mouse click.
>>
>> The text field gets locked only during the actual searching.
>>
>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>> ---
>>   kernel-shark-qt/src/KsTraceViewer.cpp | 20 +++++++++++++++-----
>>   1 file changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/KsTraceViewer.cpp
>> index a308ea0..599b687 100644
>> --- a/kernel-shark-qt/src/KsTraceViewer.cpp
>> +++ b/kernel-shark-qt/src/KsTraceViewer.cpp
>> @@ -308,8 +308,6 @@ static bool matchCond(const QString &searchText, const QString &itemText)
>>   
>>   void KsTraceViewer::_search()
>>   {
>> -	/* Disable the user input until the search is done. */
>> -	_searchLineEdit.setReadOnly(true);
> 
> Hmm, can any races happen by setting the search line read only after
> the empty checks?
> 
> Also, I found a bug. Try this on a large data file. It doesn't matter
> what data file it is.
> 
> With the Search: at its start up defaults (with Column = "#"), type
> "aaa" in the search window and then hit enter. While the search is
> going on, hit the "Next" button. See what happens.
Deadlock :)

Well spotted, thanks a lot!
I will resend the whole series.

Yordan
