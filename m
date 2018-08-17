Return-Path: <SRS0=xGmm=LA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726888AbeHQSC0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Aug 2018 14:02:26 -0400
Date: Fri, 17 Aug 2018 10:58:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
Message-ID: <20180817105842.7f14e6e7@gandalf.local.home>
In-Reply-To: <38b58799-95e7-53c0-8398-2b590dfb1192@gmail.com>
References: <20180816150729.4680-1-y.karadz@gmail.com>
        <20180816150729.4680-2-y.karadz@gmail.com>
        <20180816145219.7e91e435@gandalf.local.home>
        <0a535d0f-333c-f002-970c-33c5a8937b05@gmail.com>
        <20180817084958.11361418@gandalf.local.home>
        <38b58799-95e7-53c0-8398-2b590dfb1192@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 17 Aug 2018 17:13:23 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 17.08.2018 15:49, Steven Rostedt wrote:
> >> Hi Steven
> >>
> >> On 16.08.2018 21:52, Steven Rostedt wrote:  
> >>>> +	jfile_name = json_object_new_string(file);
> >>>> +	jtime = json_object_new_int64(st.st_mtime);  
> >>> BTW, are you saving the timestamp to make sure the trace.dat file is
> >>> the same? (assuming that the 'file' in question is trace.dat)
> >>>
> >>> What if we want to use the same "session" for different trace.dat files?
> >>>      
> >>
> >> If the timestamp is different then the import will fail (see below).
> >>
> >> If you really want to load the session with a different file you can
> >> hand-edit the Json file and make it match.  
> 
> This applies only if you want to save the entire session. The 
> configuration of the session contains number of file-specific values, 
> like PIDs, trace timestamps, marker settings (array indexes) etc. 
> Because of this it doesn't make sense to open a session with a different 
> file.
> 
> > I don't think that's very user friendly.
> > 
> > When debugging a problem, I will create several trace files, and use
> > basically the same filter for all of them. I would like to easily be
> > able to create a complex filter, save it, then reuse it for the next
> > trace.dat file I open. Hand modifying a timestamp will not be an option.
> >   
> 
> The flexibility of the configuration I/O comes in handy here. The GUI 
> has a Filter Import / Export menus. In this case only the settings of 
> the Event filter and the Adv. filter are saved to the Json file.
> 

As long as it only fails on a "full session", and not partial.

And we can have more than one file saved in the session. Hmm, I wonder
if we should add code to see if files still exist, and remove the
information if they do not.

-- Steve
