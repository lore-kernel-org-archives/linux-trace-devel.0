Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EA683;
	Tue, 28 Nov 2023 12:13:06 -0800 (PST)
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-77d6f853ba0so14579985a.0;
        Tue, 28 Nov 2023 12:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701202385; x=1701807185;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qDHSo9dBPsD9Ns7Df6fVvAtpF13sZWv6mBLxPyxYaMM=;
        b=D3Geoq5ezWiWk3xsvrpRCEvuFf/5p2eUUQE34Yx/meKTZX74aMsrejmuAdWoTAth/w
         pUZ+cQjkPo2klaAm31S9j7+NdEfctemXozc7bLQM9dXFclL6EPkEp9U8pUc4Np195bx8
         zdOX4bUUAgK+HsstUzwHi8jP/RBCTC1qyI3jPsWDw9PpA42mwPRkMlpNT0YEWCqtc8Ir
         HP+qiec4Z67eCXd135dbfAqi/0AsiS9UxaLd6k9nJgCsMDVVgQOzXBEFp3MTv+/YNGhi
         t5Ne3Lvt+uoGsUL/PjDxq7RZBVrZi9qj6NVVvkTrr2NbQEYkG/iSh920cBTE+Gus1UnX
         U3TQ==
X-Gm-Message-State: AOJu0YzFU9TwZKLHaWbkLFLGR3dAMxYtNmmf1kukJMOzb1Xl2/tAE0SD
	6ZDJ2P/TiRDWhdyumtZ6z3o=
X-Google-Smtp-Source: AGHT+IGrmY82U1LlC934lwL3/Xgf7CTUfaUJcAsXweVxnXbqS4ajmqyuvOxJ0G/CcASnMJQvXvlZjw==
X-Received: by 2002:a05:620a:899:b0:77d:7407:fc20 with SMTP id b25-20020a05620a089900b0077d7407fc20mr25140570qka.32.1701202385126;
        Tue, 28 Nov 2023 12:13:05 -0800 (PST)
Received: from maniforge (c-24-1-27-177.hsd1.il.comcast.net. [24.1.27.177])
        by smtp.gmail.com with ESMTPSA id z18-20020a05620a08d200b0076cbcf8ad3bsm4728582qkz.55.2023.11.28.12.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 12:13:04 -0800 (PST)
Date: Tue, 28 Nov 2023 14:13:02 -0600
From: David Vernet <void@manifault.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, linux-trace-users@vger.kernel.org,
	kernel-team@meta.com, julia.lawall@inria.fr,
	himadrispandya@gmail.com
Subject: Re: [PATCH] trace-cmd record: Reset PATH variable after strtok search
Message-ID: <20231128201302.GB431764@maniforge>
References: <20231128192435.36507-1-void@manifault.com>
 <20231128143044.72f0925e@gandalf.local.home>
 <20231128200856.GA431764@maniforge>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128200856.GA431764@maniforge>
User-Agent: Mutt/2.2.12 (2023-09-09)

On Tue, Nov 28, 2023 at 02:08:56PM -0600, David Vernet wrote:
> On Tue, Nov 28, 2023 at 02:30:44PM -0500, Steven Rostedt wrote:
> > On Tue, 28 Nov 2023 13:24:35 -0600
> > David Vernet <void@manifault.com> wrote:
> > 
> > > execute_program(), in the trace-cmd record subcommand, searches for a
> > > command in PATH to create an absolute path to pass to execve. The
> > > implementation uses strtok_r, which mutates the underlying string in
> > > place by replacing ':' tokens with NULL bytes. This can and does cause
> > > the PATH that's passed to execve to only contain the first entry to
> > > PATH, which can cause issues such as the following:
> > > 
> > > [root@maniforge linus]# trace-cmd record -e sched -v -e sched_stat_runtime make clean
> > > /bin/sh: line 1: uname: command not found
> > > /bin/sh: line 1: sed: command not found
> > > /bin/sh: line 1: head: command not found
> > > /bin/sh: line 1: grep: command not found
> > > /bin/sh: line 1: mkdir: command not found
> > > ...
> > > /bin/sh: line 1: mkdir: command not found
> > > /bin/sh: line 1: mkdir: command not found
> > > Makefile:681: arch//Makefile: No such file or directory
> > > make: *** No rule to make target 'arch//Makefile'.  Stop.
> > > 
> > > We should be resetting the PATH variable to the string stored in the
> > > saveptr argument to strtok_r.
> > 
> > Bah, I had this fixed locally, but never made pushed it up.
> > 
> > > 
> > > Fixes: edf9424029cc ("trace-cmd: Open code execvp routine to avoid multiple execve syscalls")
> > > Signed-off-by: David Vernet <void@manifault.com>
> > > ---
> > >  tracecmd/trace-record.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > > index bced80406816..63af11ecaa80 100644
> > > --- a/tracecmd/trace-record.c
> > > +++ b/tracecmd/trace-record.c
> > > @@ -1708,6 +1708,14 @@ static void execute_program(int argc, char **argv)
> > >  				break;
> > >  
> > >  		}
> > > +
> > > +		/*
> > > +		 * reset PATH to saveptr, as strtok_r overwrites the string
> > > +		 * returned by getenv() which backs the PATH environment
> > > +		 * variable.
> > > +		 */
> > > +		if (setenv("PATH", saveptr, 1))
> > > +			die("Failed to reset PATH to %s (%s)", saveptr, strerror(errno));
> > >  	} else {
> > >  		strncpy(buf, argv[0], sizeof(buf));
> > >  	}
> > 
> > The fix I had was this:
> > 
> > 
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index bced8040..1a461631 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -1698,6 +1698,9 @@ static void execute_program(int argc, char **argv)
> >  		if (!path)
> >  			die("can't search for '%s' if $PATH is NULL", argv[0]);
> >  
> > +		/* Do not modify the actual environment variable */
> > +		path = strdup(path);
> > +
> >  		for (entry = strtok_r(path, ":", &saveptr);
> >  		     entry; entry = strtok_r(NULL, ":", &saveptr)) {
> >  
> > @@ -1712,6 +1715,7 @@ static void execute_program(int argc, char **argv)
> >  		strncpy(buf, argv[0], sizeof(buf));
> >  	}
> >  
> > +	free(path);

Also, this should either be brought into the !strchr() branch, or path
should be initialized to NULL.

> >  	tracecmd_enable_tracing();
> >  	if (execve(buf, argv, environ)) {
> >  		fprintf(stderr, "\n********************\n");
> > 
> > Does that work for you?
> 
> That would work too, though I don't think strtok_r() is doing anything
> useful at that point. IMO it's better to either do the setenv() with
> saveptr, or change that strtok_r() to a regular strtok().
> 
> > 
> > Although, I still need to test the result of strdup().
> > 
> > -- Steve
