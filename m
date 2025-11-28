Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466347082F
	for <linux-trace-devel@vger.kernel.org>; Fri, 28 Nov 2025 03:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764300272; cv=none; b=Th2txnorEhS1XUM0wMQ7h2XIEeURX3zkO9Js3UPvqsaMaVqao9hcrLcEtcWVule6EKnFkEespJfob5ntiP0ZQacVYSaeT2ooRsIvg2LpvHWWl1IWmzT6DQNPXNMtn4GwFMcaiwsVdx6CD3t23b1xpamWclSJ5xZJxcEXG4CWO2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764300272; c=relaxed/simple;
	bh=YgtzvF1RhQ4HOgBpvxIaTef042BL2i6QkhM5k9yqyQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kFbBOrKvax8S+5taSCNoLsTyxxJadiETAlrLiXrckW7T0NZHrp9+QJ7ZTw+HmsWKsU7oQ5g6wWsaAySORLuKCaxqoT2ukl1Ee783HmoCNJ25n2dNXeQf/oU4ilxBZI/sJ95Fq7Fy0BZtpCuGYI6Tvg10eU74R2CL717Pajrz7oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E8E4C0359;
	Fri, 28 Nov 2025 03:24:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id EE6DF20023;
	Fri, 28 Nov 2025 03:24:20 +0000 (UTC)
Date: Thu, 27 Nov 2025 22:24:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Bastien Curutchet <bastien.curutchet@bootlin.com>
Cc: linux-trace-devel@vger.kernel.org, Thomas Petazzoni
 <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH] kbuffer: fix endianness flags for big-endian host
Message-ID: <20251127222419.59df3f1a@robin>
In-Reply-To: <e0bda371-2452-44bc-9956-5f6fd4f42563@bootlin.com>
References: <20251104-fix-parse-v1-1-5af9b8965886@bootlin.com>
	<e0bda371-2452-44bc-9956-5f6fd4f42563@bootlin.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: EE6DF20023
X-Stat-Signature: cym3j3z7t3naxxafuut138tp48fd3gay
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18XMruiA3KcUak4U5rWKf7i8+cwFAaba/E=
X-HE-Tag: 1764300260-992684
X-HE-Meta: U2FsdGVkX19m9690v9OPm6iaqma9vz3mPTeyyKQdpNtu9hxX5YR1iHTV1nYf1G7Ky7XS5P2A27aPlW/gLfbs8L7Zu6HUakvAYAjYGmgH1DnD8XngCRCoXgjom2AB6w0xcwIScx5gwHfHBJeOMq5sFsaGNoUJCRSVVRzJq/auIOg+TAq+PwaeIlv6MLEESR9spC07SVNe0rrpI5V1p809Wou1RkWrDqHh8UjEA+3xCkYYO+qaTIN7Zitsh8+VdhKVB1VgUcyWKiDPRyyqsAXhlEBlc14KgA1HCGiFruOFFE+3eTH7w7Ev20f4s+BtBcTnKouvHkfVaz5BIeQMNrWU8NZS4sLB2KBzTOcm8jrTfNGV8wQGvrDz0n7WqlP1DoML1AUm/r+XO98JoNtc+sVwtA==

On Thu, 27 Nov 2025 15:44:21 +0100
Bastien Curutchet <bastien.curutchet@bootlin.com> wrote:

> Hi all,
> 
> 
> Gentle ping here, has anyone had the chance to take a look at it ?

It's already been applied:

https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/commit/?id=bd74288a68cb3591acadb5bd8cd69cc4cb837651

-- Steve
