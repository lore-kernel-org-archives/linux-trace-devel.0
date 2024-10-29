Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B6200BA5
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188909; cv=none; b=Ot5c7s8H1auS8mZFEMFgBwhnhFdGMu6KO+lNGZWPIRmJcg4L4/4EVHqbHvS516VMQmYckZ9GzYosTz3DMKwgvAgNmsk8IBVf7lnJTsgecAUUwZ2cDBJXUwC3vdlCx8DkWdJQbwGM9vlz914ACPWDGYhEZiCJDwaNjSPntYtDULI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188909; c=relaxed/simple;
	bh=dhFHdDLvkouFEhL1umClPXy5V9Enlb+QiNn74C9aaPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJVVqPkSLQSYkYVWsANGvEmv/r1a4Af2/J+0SGNR5tiVIcZRujFwbjnDD5J85XzpPAu9tiawl3iQAz9tCfigBTi+rOH/hUUWa0HS+Z9SAiMN21I+HL2922JlTRbomTY/8yxcyxg2eVN7VqNkbZFYgbphhb6GCE21tPr9HOiAvXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fnxDNQTE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fnxDNQTE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jbqA9mMkQdEDRE2KPJYYb+Bc9pX4LLljhqz/9uWcZL0=;
	b=fnxDNQTEj3PjY+cdqjXgm/bHV965VvAeJKSZZJxdnp5cS4+IAT1bbLNBQKWKb+W8S2q2j3
	sUhoU4QiN+wuKFjeTinKj0VafnAUc1/JCP4aFabxouMFOQ3P0YmJ3RORy3csqtsxHpNgyi
	fRND0jDhp0Ak8wc5CuGA6KzXuU4PCAo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-599-2tE3BzTfNsyhpvW3sj9B4w-1; Tue,
 29 Oct 2024 04:01:43 -0400
X-MC-Unique: 2tE3BzTfNsyhpvW3sj9B4w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A19481955D44;
	Tue, 29 Oct 2024 08:01:42 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B010B1956088;
	Tue, 29 Oct 2024 08:01:40 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:39 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 6/8] trace-cmd lib: Prevent memory leak in tracecmd_create_event_hook()
Date: Tue, 29 Oct 2024 09:01:15 +0100
Message-ID: <20241029080117.625177-7-jmarchan@redhat.com>
In-Reply-To: <20241029080117.625177-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20241029080117.625177-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Free hook and hook->str in the error path.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-hooks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-hooks.c b/lib/trace-cmd/trace-hooks.c
index a58b5356..aa12f6e9 100644
--- a/lib/trace-cmd/trace-hooks.c
+++ b/lib/trace-cmd/trace-hooks.c
@@ -151,6 +151,8 @@ struct hook_list *tracecmd_create_event_hook(const char *arg)
 
 invalid_tok:
 	tracecmd_warning("Invalid hook format '%s'", arg);
+	free(hook->str);
+	free(hook);
 	return NULL;
 }
 
-- 
2.47.0

