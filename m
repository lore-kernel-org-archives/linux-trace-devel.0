Return-Path: <SRS0=DGv/=O2=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51826 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbeLQRCS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Dec 2018 12:02:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id s14so13110876wmh.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Dec 2018 09:02:16 -0800 (PST)
Subject: Re: [PATCH v2 3/8] kernel-shark-qt: Make the parallelized search
 stoppable
To: Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
 <20181214125212.9637-4-ykaradzhov@vmware.com>
 <20181214121726.41d23547@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <99c82998-e64e-ef51-f432-b62aa71a371c@gmail.com>
Date: Mon, 17 Dec 2018 19:02:13 +0200
MIME-Version: 1.0
In-Reply-To: <20181214121726.41d23547@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 14.12.18 г. 19:17 ч., Steven Rostedt wrote:
> On Fri, 14 Dec 2018 12:52:37 +0000
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> So far only the single-threaded search inside the "Latency" and "Info"
>> columns can be stopped by the "stop search" button. This patch makes it
>> possible to stop also the parallelized search. Note that after stopping
>> the parallelized search, the list of matches will contain entries which
>> may not be consecutive, because each thread was searching in its own
>> subset of the data and was stoped at an arbitrary position in this
>> subset.
>>
> 
> Also I noticed:
> 
>    _searchStopButton(QIcon::fromTheme("process-stop"), "", this),
> 
> I don't have a "process-stop" theme. I'm not running KDE. All I see is
> a blank button. Is there a way to add text to it too, or define the
> theme if it is not set?
> 

This is strange. This line means that the button have to show the 
"process-stop" icon and the version (look) of the icon has to be 
determined form your current theme. Everywhere in the code I use the 
standardized icon names provided here

https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html 


Looks like for some reason your theme does not provide this icon.

Thanks!
Yordan

> -- Steve
> 
