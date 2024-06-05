Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8535E194A74
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594983; cv=none; b=g61dyna1QZFTRdGGONGFTVQlajghgMU+7QhkCDRIgK8w9uds2OmReQlHMamvDvHJjWagYm5Vcw4ZNH8StA2Eo9gkPhJgAsmI2J22UQdwfNG/owfMu9ZVJ7KKx0t7O9wSjlnEaTUEpvXC5T1vkgOBsFBYvwFIjnL/qPA/hHBDyc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594983; c=relaxed/simple;
	bh=Eo017dL4L2AQ3GQQ/r3v/2KABfrIzwaLjT2sHJzET+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lg8eMzk9s7HTqNgMXh9IzXoz9MUGKkCR4K4ezdy87l9r1wgSxZ5gOMpiPVgT9jWHGEbPFt0H0EXEXpLgQq4ZZgn3rvyh0V+5I9tAK6ZnBXvdaxL6uGlOoob4JZp8Rq3ByBqAqTN5MyKSla94c3UBLs2LoJReakoT/fqv7LtnM+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UPf8+JC1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPf8+JC1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TJJIQYuOmgru39ZnQ9/hAIKnRVP1qntNsnJQsmydn6E=;
	b=UPf8+JC1UesexES8G2XDaX2XdO28TC2a+yfSB21q0PcHQ9G7lkGhA0f7OzeXxyboC3zVTA
	Zb6Flq2rAI++DqZfJ+cMbmDHHo2L6ws8A/+cvLRTvjFIbcVw6c69w429uw9apujRe2qlRB
	+s6+eMpyJit72SevjpJJKBd+289lItE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-sbLPJPVwPTOSAkgTveL2bQ-1; Wed, 05 Jun 2024 09:42:57 -0400
X-MC-Unique: sbLPJPVwPTOSAkgTveL2bQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D45DD85A58B;
	Wed,  5 Jun 2024 13:42:56 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 07107201EAC2;
	Wed,  5 Jun 2024 13:42:54 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:54 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 33/38] trace-cmd record: prevent memory corruption in parse_record_options()
Date: Wed,  5 Jun 2024 15:40:48 +0200
Message-ID: <20240605134054.2626953-34-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

In parse_record_options() we can end up using a deleted instance after
options have been parsed. This can be triggered by the following
command:
$ trace-cmd record -v -e block -B foo  ls

We probably need a proper to avoid to end up in this situation, but in
the mean time, check that the current instance isn't marked for
deletion before calling remove_instances(). That at least prevent an
hard to debug memory corruption bug.

Fixes a USE_AFTER_FREE error (CWE-416)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 770e775b..dc3e5285 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6909,6 +6909,8 @@ static void parse_record_options(int argc,
 		}
 	}
 
+	if (ctx->instance->delete)
+		die("Instance to be deleted is still used");
 	remove_instances(del_list);
 
 	/* If --date is specified, prepend it to all guest VM flags */
-- 
2.44.0

