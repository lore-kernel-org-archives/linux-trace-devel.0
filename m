Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbeH3UUe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 16:20:34 -0400
Date: Thu, 30 Aug 2018 12:17:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/7] kernel-shark-qt: Add plugin infrastructure to be
 used by the Qt-baset KS.
Message-ID: <20180830121738.26a16812@gandalf.local.home>
In-Reply-To: <b7b16558-a42f-55d8-7bb1-9f6c868d1897@gmail.com>
References: <20180829164224.20677-1-y.karadz@gmail.com>
        <20180829164224.20677-2-y.karadz@gmail.com>
        <20180829163253.7ba150f5@gandalf.local.home>
        <b7b16558-a42f-55d8-7bb1-9f6c868d1897@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 30 Aug 2018 14:45:16 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 29.08.2018 23:32, Steven Rostedt wrote:
> >> +	struct kshark_event_handler **last = handlers;
> >> +	struct kshark_event_handler *list;
> >> +
> >> +	for (list = *handlers; list; list = list->next) {  
> > You can simplify this to:
> > 
> > 	for (last = handlers; *last; last = &(*last)->next) {
> > 		list = *last;
> >   
> >> +		if (list->id == event_id &&
> >> +		    list->event_func == evt_func &&
> >> +		    list->draw_func == dw_func) {
> >> +			*last = list->next;
> >> +			free(list);
> >> +			return;
> >> +		}
> >> +  
> >   
> >> +		last = &list->next;  
> > Then you can remove the above line.
> >   
> 
> I am confused. For me the two implementations of this for-loop are 
> identical. Where is the simplification?
> 
>

I'll just re-explaining it here from our phone conf:

>From a compiler point of view the two versions are drastically
different:

I created this file:

$ cat lists.c 
#include <stdlib.h>

struct kshark_event_handler {
	struct kshark_event_handler	*next;
	int				id;
};

void func1(struct kshark_event_handler **handlers, int event_id)
{
	struct kshark_event_handler **last = handlers;
	struct kshark_event_handler *list;

	for (list = *handlers; list; list = list->next) {
		if (list->id == event_id) {
			*last = list->next;
			free(list);
			return;
		}

		last = &list->next;
	}
}

void func2(struct kshark_event_handler **handlers, int event_id)
{
	struct kshark_event_handler **last;

	for (*last = *handlers; *last; last = &(*last)->next) {
		if ((*last)->id == event_id) {
			struct kshark_event_handler *list;
			list = *last;
			*last = list->next;
			free(list);
			return;
		}
	}
}


And complied it like so:

 $ gcc -O2 -c -o /tmp/lists.o lists.c

And then did an objdump:

 $ objdump -dr /tmp/lists.o

/tmp/lists.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <func1>:
   0:	48 8b 17             	mov    (%rdi),%rdx
   3:	48 85 d2             	test   %rdx,%rdx
   6:	74 18                	je     20 <func1+0x20>
   8:	3b 72 08             	cmp    0x8(%rdx),%esi
   b:	75 0b                	jne    18 <func1+0x18>
   d:	eb 2a                	jmp    39 <func1+0x39>
   f:	90                   	nop
  10:	39 70 08             	cmp    %esi,0x8(%rax)
  13:	74 13                	je     28 <func1+0x28>
  15:	48 89 c2             	mov    %rax,%rdx
  18:	48 8b 02             	mov    (%rdx),%rax
  1b:	48 85 c0             	test   %rax,%rax
  1e:	75 f0                	jne    10 <func1+0x10>
  20:	c3                   	retq   
  21:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  28:	48 89 d7             	mov    %rdx,%rdi
  2b:	48 8b 10             	mov    (%rax),%rdx
  2e:	48 89 17             	mov    %rdx,(%rdi)
  31:	48 89 c7             	mov    %rax,%rdi
  34:	e9 00 00 00 00       	jmpq   39 <func1+0x39>
			35: R_X86_64_PLT32	free-0x4
  39:	48 89 d0             	mov    %rdx,%rax
  3c:	eb ed                	jmp    2b <func1+0x2b>
  3e:	66 90                	xchg   %ax,%ax

0000000000000040 <func2>:
  40:	48 8b 3f             	mov    (%rdi),%rdi
  43:	48 89 3c 25 00 00 00 	mov    %rdi,0x0
  4a:	00 
  4b:	48 85 ff             	test   %rdi,%rdi
  4e:	74 1d                	je     6d <func2+0x2d>
  50:	3b 77 08             	cmp    0x8(%rdi),%esi
  53:	75 10                	jne    65 <func2+0x25>
  55:	eb 19                	jmp    70 <func2+0x30>
  57:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5e:	00 00 
  60:	39 77 08             	cmp    %esi,0x8(%rdi)
  63:	74 0b                	je     70 <func2+0x30>
  65:	48 8b 3f             	mov    (%rdi),%rdi
  68:	48 85 ff             	test   %rdi,%rdi
  6b:	75 f3                	jne    60 <func2+0x20>
  6d:	c3                   	retq   
  6e:	66 90                	xchg   %ax,%ax
  70:	e9 00 00 00 00       	jmpq   75 <func2+0x35>
			71: R_X86_64_PLT32	free-0x4


The first way uses two pointers "list" and "last" to walk down the
list. The second way uses just the "last" pointer to iterate down the
list and only uses the list variable to free the object. From the
source code it doesn't look like there's much difference, but when you
compile it (with optimization -O2) the difference becomes much more
apparent.

-- Steve
