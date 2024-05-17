Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2EC389
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 May 2024 00:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715906443; cv=none; b=AEO9jzFjlkUKKX/zk9VPAmoU0jK2/9MgOkEX5BV+HNh4HWqPMdh25ACgRM/BQ+zY0boYEabxUfozNM600H/7brue8+w7tB1vDQ+XlkqZduxvzxPie525XZJ+cKvDuthgp/1MPHgJTWSSRd0PTnBrTd86pMAcjGdZjana6YcONRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715906443; c=relaxed/simple;
	bh=5QOfyT1YNxnrPLu9Kev0HG1NX5SA0vsv6gaz63BS5nw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMTGspo/LN/88E0ehdBM5cMybDs6oPLQD+5OGGYEh9BY6Z5uyaU2GrXrTRGfD3DCrKV+Nl2qYw6XIIt9rmE5ecfhlndSPiobyuwkBg0nEf9yZw69uyhG1youds8ILQPue5NBrHUsF2gt+79Llf52yksRf1pJswYH5UCvJ1cl0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7ECC113CC;
	Fri, 17 May 2024 00:40:42 +0000 (UTC)
Date: Thu, 16 May 2024 20:40:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Rogers <irogers@google.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1] libtraceevent: Fix event-parse memory leak in
 process_cond
Message-ID: <20240516204041.63f986be@rorschach.local.home>
In-Reply-To: <CAP-5=fWQOB5QcrQ2rst0uq-B2A0BtNzSatFdtqG8+4Ba80G8MQ@mail.gmail.com>
References: <20240430073908.1706482-1-irogers@google.com>
	<CAP-5=fWQOB5QcrQ2rst0uq-B2A0BtNzSatFdtqG8+4Ba80G8MQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Apr 2024 01:03:15 -0700
Ian Rogers <irogers@google.com> wrote:

> > print fmt: "%s%s%s%s%s", __print_symbolic(REC->exception, { 0, "#" "DE" }, { 1, "#" "DB" }, { 3, "#" "BP" }, { 4, "#" "OF" }, { 5, "#" "BR" }, { 6, "#" "UD" }, { 7, "#" "NM" }, { 8, "#" "DF" }, { 10, "#" "TS" }, { 11, "#" "NP" }, { 12, "#" "SS" }, { 13, "#" "GP" }, { 14, "#" "PF" }, { 16, "#" "MF" }, { 17, "#" "AC" }, { 18, "#" "MC" }), !REC->has_error ? "" : " (", !REC->has_error ? "" : __print_symbolic(REC->error_code, { }), !REC->has_error ? "" : ")", REC->reinjected ? " [reinjected]" : ""
> > ```  
> 
> Some more context. The place in the input where the leak appears is of
> a string "?" read as a token at:
> ? "" : __print_symbolic(REC->error_code, { }), !REC->has_error ? "" :
> ")", REC->reinjected ? " [reinjected]" : ""

That probably is the cause. That should get handled.

-- Steve
