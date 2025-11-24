Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA6C311C1F
	for <linux-trace-devel@vger.kernel.org>; Mon, 24 Nov 2025 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764003485; cv=none; b=DWXgVDuU+ZqxLg1xkvBeL80kNvwHWJyhfXnnt+TKqagnJLkEBGcAf78/0FPMtdHAyEr69PhA6/1oxUDzq02+yU9kTwtou9ItK23nSfRgvOEvIti09wujxG6+19/vf1FHgwduu+Q/GQ6krF9vgS6FoILVUKUl2DlPEKlRMUmXu0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764003485; c=relaxed/simple;
	bh=Ndn63ErfSiYhfewhd5QrGOOGzHZBp+qvguqqe9rNX1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=teJKCyCyWonXZmcVJ2oTv///JRY1vYv+TjAHPySpgN/6OPDjjLyxKnOJKTDca4MB1rjAm0sgnvz6TlDv1NFmOZLGYqjWLK9O0clfRA7KxxFnUm7tJpqQU2ihx0xABkV++w2zlOt2Nw9kbBnaEAw2gyPyyOLjjXfLdQB0rKn9gOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60AAE1604FB;
	Mon, 24 Nov 2025 16:58:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id CD20520033;
	Mon, 24 Nov 2025 16:57:58 +0000 (UTC)
Date: Mon, 24 Nov 2025 11:58:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
Cc: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] libtracecmd: fix memory leak on partial reverse
 iteration
Message-ID: <20251124115840.7a4de310@gandalf.local.home>
In-Reply-To: <e113f523ef34efe5edab24d5dbad5cd40db9ea26.camel@siemens.com>
References: <20251121134749.1530855-1-felix.moessbauer@siemens.com>
	<20251121120117.20e82d9e@gandalf.local.home>
	<e113f523ef34efe5edab24d5dbad5cd40db9ea26.camel@siemens.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i9kdgn5fmxoy9pcfqo4qmsta4ksa4xsr
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: CD20520033
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+LkpqxNeIuDNS4XIgHLLHmMlUIQL/f034=
X-HE-Tag: 1764003478-176072
X-HE-Meta: U2FsdGVkX18S+CrfimPBdjuYnXOFou3mW5q4Zvo3AczYp0Cw5H1Bgyv1GepQj0cYXXQvURuewDqCqucXN1Z/kYuVJk85YINmKmNxFyfG+0CyaoAfPeAwS0qs4K3KsPVa/9SLNVQzWh3gm2xHNMYfCUxA8sik6xUupAZrZtZpGwOvsVCsf0zq13AUKM/ISHKxSBVFOnBatk6RwOV0ERQynA6pQVc1iyp1MwjdZsrxayvpxvIN24T+9+jSQSBrxJ0ig7mRXEmSf6HJLUA+cX6Yr8YtvQ5aloEt2qYKaV690XuhRZ+z4kqJs8CK0uTQkluetB6lFC/AC76oXBkIeQ4HAQCZBK8CVGD7

On Mon, 24 Nov 2025 09:14:06 +0000
"MOESSBAUER, Felix" <felix.moessbauer@siemens.com> wrote:

> Hi,
> 
> while thinking about it again, I noticed that the callback based
> iteration interface relies on some assumptions which are not
> documented. While probably obvious, it should be documented what is NOT
> allowed to be done inside the callback (i.e. calling any 
> tracecmd_iterate_* function, but also calling tracecmd_read_* and
> alike?).

Agreed that this should be documented. I wouldn't say it is "NOT" allowed,
but instead specify what the side effects are.

I think stating how the iterator is somewhat implemented is good, as it
should allow the user to assume its behavior.

Basically saying that the internal cursor of the iterator is:

  do {
	record = tracecmd_read_next_data(handle, &cpu);
	if (!record)
		break;
	ret = callback(handle, record, cpu, data);
  } while (!ret);

And state that any reads in the callback can change the iterator, and cause
it to behave differently, just like it would in the above code.

Hmm, my fix of the reverse code had the last record get read again. That's
different than the iterator itself. I should get rid of the "- 4" and make
the continue read the next record after the one last read too.

Thanks,

-- Steve
