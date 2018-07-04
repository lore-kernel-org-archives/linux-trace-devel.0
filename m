Return-Path: <SRS0=h6hK=JU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:40887 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932576AbeGDLfV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jul 2018 07:35:21 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 6BF4F18016297
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jul 2018 11:26:39 +0000 (UTC)
Date: Wed, 04 Jul 2018 07:26:36 -0400
In-Reply-To: <da0c7baa-2845-7873-3015-b250dd93e79e@gmail.com>
References: <20180703162130.082810105@goodmis.org> <da0c7baa-2845-7873-3015-b250dd93e79e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH 0/3] kernel-shark-qt: Merge kshark_load_data_records/entries()
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <EB1A5869-EAD2-4D4C-9C50-AF34D9A4C451@goodmis.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

[Sorry for the top post, it's a US holiday]

Can we just disable warnings for structures? I'd like to keep the function warnings on.

-- Steve


On July 4, 2018 7:17:26 AM EDT, "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>
>
>On  3.07.2018 19:21, Steven Rostedt wrote:
>> This works to consolidate the functions kshark_load_data_records()
>> with kshark_load_data_entries(). It adds some helper functions
>> for the two to use to simplify the code.
>> 
>> Note, doxygen warns that struct rec_list is not documented. Really?
>> Such a simple structure doesn't really require documentation. Is
>> there a way to shut it up? Or I can just add code to say
>>   /** Shut doxygen up! ;-)
>
>Yes, you can do
>
>//! @cond Doxygen_Suppress
>
>struct rec_list {
>	struct pevent_record	*rec;
>	struct rec_list		*next;
>};
>
>//! @endcond
>
>Another solutions is to turn off all warnings. This can be done by
>adding
>
>  WARN_IF_UNDOCUMENTED = NO
>
>to doc/dox_config
>
>On the other hand, do we expect the normal users to build doxygen 
>documentation, if this documentation is available at 
>http://kernelshark.org? So maybe we can tolerate having some warnings.
>
>Actually this reminds me that there is a third solution. We can make 
>this warnings invisible for the normal users by redirecting the 
>doxygen's stderr to a file.
>
>What do you think?
>
>Yordan
>
>
>> Yordan, please review these.
>> 
>> Steven Rostedt (VMware) (3):
>>        kernel-shark-qt: Move declarations to top in datafilter.c
>example
>>        kernel-shark-qt: Consolidate load_data_entries and
>load_data_records
>>        kernel-shark-qt: Add helper function to find the next_cpu in
>kshark_load_data_*()
>> 
>> ----
>>   kernel-shark-qt/examples/datafilter.c |   5 +-
>>   kernel-shark-qt/src/libkshark.c       | 253
>++++++++++++++++++++--------------
>>   2 files changed, 151 insertions(+), 107 deletions(-)
>> 

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
